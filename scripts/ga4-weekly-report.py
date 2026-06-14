#!/usr/bin/env python3
"""Query GA4 for a weekly analytics summary and post to Telegram.

Credentials (in priority order):
  - GA4_SERVICE_KEY env var: full JSON string of the service account key
  - GA4_KEY_FILE env var or ~/.config/nieder-me/ga4-reader.json as fallback
  - TELEGRAM_BOT_TOKEN env var or ~/.claude/channels/telegram/.env as fallback
  - TELEGRAM_CHAT_ID env var or hardcoded default
"""

import json
import os
import tempfile
import urllib.request
import urllib.parse
from datetime import date, timedelta
from pathlib import Path
from google.oauth2 import service_account
from google.analytics.data_v1beta import BetaAnalyticsDataClient
from google.analytics.data_v1beta.types import (
    DateRange, Dimension, Filter, FilterExpression, Metric, RunReportRequest,
    OrderBy
)

# ── credentials ───────────────────────────────────────────────────────────────

PROPERTY_ID    = "531720858"
IMPERSONATE_AS = "john@nieder.me"
SCOPES         = ["https://www.googleapis.com/auth/analytics.readonly"]
CHAT_ID        = os.environ.get("TELEGRAM_CHAT_ID", "26108228")

# GA4 key: env var (CI) → local file (dev)
_key_json = os.environ.get("GA4_SERVICE_KEY")
if _key_json:
    _tmp = tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False)
    _tmp.write(_key_json)
    _tmp.flush()
    KEY_FILE = _tmp.name
else:
    KEY_FILE = os.environ.get("GA4_KEY_FILE",
                              str(Path.home() / ".config/nieder-me/ga4-reader.json"))

# Telegram token: env var (CI) → local .env file (dev)
_tg_token = os.environ.get("TELEGRAM_BOT_TOKEN")
if not _tg_token:
    _tg_env = Path.home() / ".claude/channels/telegram/.env"
    if _tg_env.exists():
        for line in _tg_env.read_text().splitlines():
            if line.startswith("TELEGRAM_BOT_TOKEN="):
                _tg_token = line.split("=", 1)[1].strip()
TG_TOKEN = _tg_token

# ── GA4 client ────────────────────────────────────────────────────────────────

credentials = service_account.Credentials.from_service_account_file(
    KEY_FILE, scopes=SCOPES, subject=IMPERSONATE_AS
)
client = BetaAnalyticsDataClient(credentials=credentials)

today      = date.today()
week_start = today - timedelta(days=today.weekday())
lw_start   = week_start - timedelta(days=7)
lw_end     = week_start - timedelta(days=1)

PRODUCTION_HOST_FILTER = FilterExpression(
    filter=Filter(
        field_name="hostName",
        string_filter=Filter.StringFilter(
            match_type=Filter.StringFilter.MatchType.FULL_REGEXP,
            value=r"^(www\.)?nieder\.me$",
        ),
    )
)

def run_report(start, end, dimensions, metrics, limit=10, order_by=None):
    req = RunReportRequest(
        property=f"properties/{PROPERTY_ID}",
        date_ranges=[DateRange(start_date=str(start), end_date=str(end))],
        dimension_filter=PRODUCTION_HOST_FILTER,
        dimensions=[Dimension(name=d) for d in dimensions],
        metrics=[Metric(name=m) for m in metrics],
        limit=limit,
        order_bys=order_by or [],
    )
    return client.run_report(req)

by_sessions = lambda name="sessions": [
    OrderBy(metric=OrderBy.MetricOrderBy(metric_name=name), desc=True)
]

totals      = run_report(week_start, today, [],
                         ["sessions", "activeUsers", "screenPageViews", "newUsers"])
overview    = run_report(week_start, today, ["date"],
                         ["sessions", "activeUsers", "screenPageViews"], limit=7,
                         order_by=[OrderBy(dimension=OrderBy.DimensionOrderBy(dimension_name="date"))])
lw_overview = run_report(lw_start, lw_end, [],
                         ["sessions", "activeUsers", "screenPageViews", "newUsers"])
top_pages   = run_report(week_start, today, ["pagePath"],
                         ["screenPageViews", "activeUsers"], limit=10,
                         order_by=by_sessions("screenPageViews"))
sources     = run_report(week_start, today, ["sessionSource", "sessionMedium"],
                         ["screenPageViews", "activeUsers"], limit=10,
                         order_by=by_sessions("screenPageViews"))
countries   = run_report(week_start, today, ["country"],
                         ["sessions", "activeUsers"], limit=8, order_by=by_sessions())
devices     = run_report(week_start, today, ["deviceCategory"],
                         ["sessions", "activeUsers"], order_by=by_sessions())
new_ret     = run_report(week_start, today, ["newVsReturning"],
                         ["sessions", "activeUsers"], order_by=by_sessions())
landing     = run_report(week_start, today, ["landingPagePlusQueryString"],
                         ["sessions", "bounceRate", "screenPageViews"], limit=12,
                         order_by=by_sessions())

# ── helpers ───────────────────────────────────────────────────────────────────

def pct_bar(val, total, width=10):
    filled = round(val / total * width) if total else 0
    return "█" * filled + "░" * (width - filled)

def delta(now, prev):
    if not prev: return ""
    p = (now - prev) / prev * 100
    return f" ({'+' if p >= 0 else ''}{p:.0f}% vs last wk)"

def clean_label(value, fallback="(not set)"):
    value = value.strip()
    return value if value else fallback

def unit(value, singular, plural=None):
    return singular if value == 1 else (plural or f"{singular}s")

# ── totals ────────────────────────────────────────────────────────────────────

tw_s = tw_u = tw_v = tw_new = 0
if totals.rows:
    tw_s, tw_u, tw_v, tw_new = (int(totals.rows[0].metric_values[i].value) for i in range(4))
lw_s = lw_u = lw_v = 0
if lw_overview.rows:
    lw_s, lw_u, lw_v = (int(lw_overview.rows[0].metric_values[i].value) for i in range(3))

new_row = next((r for r in new_ret.rows if r.dimension_values[0].value == "new"), None)
ret_row = next((r for r in new_ret.rows if r.dimension_values[0].value == "returning"), None)
tw_ret = int(ret_row.metric_values[1].value) if ret_row else 0

source_rows = []
for row in sources.rows:
    src, med = row.dimension_values[0].value, row.dimension_values[1].value
    views = int(row.metric_values[0].value)
    users = int(row.metric_values[1].value)
    if src == "(not set)" and med == "(not set)":
        label = "unattributed in GA4"
    else:
        label = f"{src} / {med}"
    source_rows.append((label, views, users))

known_landing_rows = []
unknown_landing_sessions = 0
for row in landing.rows:
    path = row.dimension_values[0].value
    s = int(row.metric_values[0].value)
    bounce = float(row.metric_values[1].value) * 100
    views = int(row.metric_values[2].value)
    if not path or views == 0:
        unknown_landing_sessions += s
        continue
    known_landing_rows.append((path, s, bounce, views))

# ── build report string ───────────────────────────────────────────────────────

lines = []
W = 52

lines += [f"{'═'*W}",
          f"  nieder.me  ·  {week_start} → {today}",
          f"{'═'*W}", ""]

lines += [f"  {'Sessions:':<14}{tw_s:>6,}{delta(tw_s, lw_s)}",
          f"  {'Users:':<14}{tw_u:>6,}{delta(tw_u, lw_u)}",
          f"  {'Pageviews:':<14}{tw_v:>6,}{delta(tw_v, lw_v)}",
          f"  {'New users:':<14}{tw_new:>6,}   Returning: {tw_ret:,}"]

lines += ["", "  Daily breakdown", f"  {'─'*40}"]
for row in overview.rows:
    d = row.dimension_values[0].value
    d_fmt = f"{d[0:4]}-{d[4:6]}-{d[6:]}"
    s, u = int(row.metric_values[0].value), int(row.metric_values[1].value)
    lines.append(f"  {d_fmt}  {pct_bar(s, tw_s)}  {s:>4} sess  {u:>4} users")

lines += ["", "  Traffic sources (by views)", f"  {'─'*40}"]
for label, views, users in source_rows:
    lines.append(
        f"  {pct_bar(views, tw_v)}  {label:<28} "
        f"{views:>4} {unit(views, 'view'):<5}  {users:>4} {unit(users, 'user')}"
    )

lines += ["", "  Countries", f"  {'─'*40}"]
for row in countries.rows:
    country = clean_label(row.dimension_values[0].value)
    s = int(row.metric_values[0].value)
    lines.append(f"  {pct_bar(s, tw_s)}  {country:<22} {s:>4}")

lines += ["", "  Devices", f"  {'─'*40}"]
for row in devices.rows:
    dev = row.dimension_values[0].value
    s, u = int(row.metric_values[0].value), int(row.metric_values[1].value)
    lines.append(f"  {pct_bar(s, tw_s)}  {dev:<14} {s:>4} sess  {u:>4} users")

lines += ["", "  Top landing pages", f"  {'─'*40}"]
for path, s, bounce, views in known_landing_rows[:8]:
    path = path[:42]
    lines.append(f"  {path:<42}  {s:>3} sess  {views:>3} views  {bounce:.0f}% bounce")
if unknown_landing_sessions:
    lines.append(f"  {'unattributed by GA4':<42}  {unknown_landing_sessions:>3} sess    0 views")

lines += ["", "  Top pages (by views)", f"  {'─'*40}"]
for row in top_pages.rows:
    path = row.dimension_values[0].value
    v    = int(row.metric_values[0].value)
    lines.append(f"  {pct_bar(v, tw_v)}  {path:<34} {v:>4} views")

lines.append("")
report = "\n".join(lines)

# ── print + send ──────────────────────────────────────────────────────────────

print(report)

if TG_TOKEN:
    payload = urllib.parse.urlencode({
        "chat_id": CHAT_ID,
        "text": f"```\n{report}\n```",
        "parse_mode": "MarkdownV2",
    }).encode()
    url = f"https://api.telegram.org/bot{TG_TOKEN}/sendMessage"
    try:
        with urllib.request.urlopen(url, data=payload, timeout=10) as resp:
            result = json.loads(resp.read())
            if not result.get("ok"):
                print(f"Telegram error: {result}", flush=True)
    except Exception as e:
        print(f"Telegram send failed: {e}", flush=True)
else:
    print("(No TELEGRAM_BOT_TOKEN — skipping Telegram delivery)", flush=True)
