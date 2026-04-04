const logoMarks = Array.from(document.querySelectorAll(".logo-mark, .mobile-logo-mark"));
const topLogoLinks = Array.from(
  document.querySelectorAll(
    '.logo-link[href="#top"], .mobile-logo-link[href="#top"], .styleguide-top-anchor[href="#top"], .global-nav-anchor[href="#top"], .mobile-nav-anchor[href="#top"]'
  )
);
const themeToggles = Array.from(document.querySelectorAll(".theme-toggle"));
const colsToggles = Array.from(document.querySelectorAll(".cols-toggle"));
const emailLinks = Array.from(document.querySelectorAll("[data-email-link]"));
const homeRailNav = document.querySelector(".global-nav-home");
const themeColorMeta = document.querySelector('meta[name="theme-color"]');
const colorSchemeMeta = document.querySelector('meta[name="color-scheme"]');
const THEME_STORAGE_KEY = "nieder.theme";
const COLS_TOGGLE_STORAGE_KEY = "nieder.cols-grid-visible";
const LIGHT_THEME_COLOR = "#ffffff";
const DARK_THEME_COLOR = "#000000";
const scrollToPageTop = () => {
  window.scrollTo({ top: 0, behavior: "smooth" });
  if (window.location.hash) {
    history.replaceState(
      null,
      "",
      `${window.location.pathname}${window.location.search}`
    );
  }
};

if (emailLinks.length > 0) {
  const emailAddress = String.fromCharCode(
    106, 111, 104, 110, 64, 110, 105, 101, 100, 101, 114, 46, 109, 101
  );
  emailLinks.forEach((emailLink) => {
    emailLink.href = `mailto:${emailAddress}`;
  });
}

{
  const caseStudyPromos = Array.from(document.querySelectorAll(".case-study-promo"));

  const toCssUrl = (value) => {
    const source = String(value || "").trim();
    if (!source) return "";
    const absoluteSource = new URL(source, window.location.href).href;
    return `url("${absoluteSource.replace(/"/g, '\\"')}")`;
  };

  const normalizeFocus = (value) => {
    const token = String(value || "").trim().toLowerCase();
    if (!token || token === "middle" || token === "center" || token === "centre") {
      return "center center";
    }
    if (token === "left") return "left center";
    if (token === "right") return "right center";
    return token;
  };

  caseStudyPromos.forEach((promo) => {
    const logo = promo.querySelector(".case-study-promo-logo");
    const logoSource = String(promo.dataset.logo || "").trim();
    const desktopBackground = toCssUrl(promo.dataset.bgDesktop);
    const mobileBackground = toCssUrl(promo.dataset.bgMobile || promo.dataset.bgDesktop);
    const desktopFocus = normalizeFocus(promo.dataset.focusDesktop);
    const mobileFocus = normalizeFocus(promo.dataset.focusMobile || promo.dataset.focusDesktop);

    if (logo && logoSource) {
      logo.setAttribute("src", logoSource);
    }
    if (desktopBackground) {
      promo.style.setProperty("--case-study-promo-bg-desktop", desktopBackground);
    }
    if (mobileBackground) {
      promo.style.setProperty("--case-study-promo-bg-mobile", mobileBackground);
    }
    promo.style.setProperty("--case-study-promo-focus-desktop", desktopFocus);
    promo.style.setProperty("--case-study-promo-focus-mobile", mobileFocus);
  });
}

{
  const caseStudyCarousels = Array.from(document.querySelectorAll(".case-study-block-carousel"));

  caseStudyCarousels.forEach((carousel) => {
    const track = carousel.querySelector(".case-study-carousel-track");
    const prev = carousel.querySelector("[data-carousel-prev]");
    const next = carousel.querySelector("[data-carousel-next]");
    const status = carousel.querySelector("[data-carousel-status]");
    const controls = carousel.querySelector(".case-study-carousel-controls");

    if (!track || !prev || !next || !status || !controls) {
      return;
    }

    const slides = Array.from(track.querySelectorAll(".case-study-carousel-slide"));
    if (slides.length < 2) {
      return;
    }

    let index = 0;

    const applySlide = () => {
      slides.forEach((slide, slideIndex) => {
        slide.hidden = slideIndex !== index;
        slide.setAttribute("aria-hidden", String(slideIndex !== index));
      });
      prev.disabled = index === 0;
      next.disabled = index === slides.length - 1;
      status.textContent = `${index + 1} / ${slides.length}`;
    };

    controls.hidden = false;
    carousel.dataset.carouselEnhanced = "true";
    applySlide();

    prev.addEventListener("click", () => {
      index = Math.max(0, index - 1);
      applySlide();
    });

    next.addEventListener("click", () => {
      index = Math.min(slides.length - 1, index + 1);
      applySlide();
    });
  });
}

{
  const scrollCarousels = [
    {
      track: document.querySelector(".topper-columns"),
      itemSelector: ":scope > p",
      dotsClassName: "topper-carousel-dots",
    },
    {
      track: document.querySelector(".experience-columns-carousel"),
      itemSelector: ":scope > .experience-column",
      dotsClassName: "experience-carousel-dots",
    },
  ].filter((entry) => entry.track);

  if (scrollCarousels.length > 0) {
    const mobileQuery = window.matchMedia("(max-width: 700px)");

    const clampIndex = (index, length) => Math.max(0, Math.min(index, length - 1));

    const getAnchorOffset = (track) => {
      const styles = window.getComputedStyle(track);
      const paddingLeft = Number.parseFloat(styles.paddingLeft) || 0;
      return track.getBoundingClientRect().left + paddingLeft;
    };

    const updateDots = (state) => {
      const anchorLeft = getAnchorOffset(state.track);
      const nextIndex = state.items.reduce((bestIndex, item, itemIndex) => {
        const distance = Math.abs(item.getBoundingClientRect().left - anchorLeft);
        const bestDistance = Math.abs(state.items[bestIndex].getBoundingClientRect().left - anchorLeft);
        return distance < bestDistance ? itemIndex : bestIndex;
      }, 0);

      state.dotNodes.forEach((dot, dotIndex) => {
        const isActive = dotIndex === nextIndex;
        dot.classList.toggle("is-active", isActive);
        dot.setAttribute("aria-pressed", String(isActive));
      });
    };

    const states = scrollCarousels
      .map(({ track, itemSelector, dotsClassName }) => {
        const items = Array.from(track.querySelectorAll(itemSelector));
        if (items.length < 2) return null;

        const dots = document.createElement("div");
        dots.className = `carousel-page-dots ${dotsClassName}`;
        dots.setAttribute("aria-label", "Carousel pages");

        const dotNodes = items.map((item, index) => {
          const dot = document.createElement("button");
          dot.type = "button";
          dot.className = "carousel-page-dot";
          dot.setAttribute("aria-label", `Go to page ${index + 1}`);
          dot.setAttribute("aria-pressed", String(index === 0));
          dot.addEventListener("click", () => {
            const paddingLeft = Number.parseFloat(window.getComputedStyle(track).paddingLeft) || 0;
            track.scrollTo({
              left: Math.max(0, item.offsetLeft - paddingLeft),
              behavior: "smooth",
            });
          });
          dots.appendChild(dot);
          return dot;
        });

        track.insertAdjacentElement("afterend", dots);
        return { track, items, dots, dotNodes };
      })
      .filter(Boolean);

    if (states.length > 0) {
      const syncVisibility = () => {
        const isMobile = mobileQuery.matches;
        states.forEach((state) => {
          state.dots.hidden = !isMobile;
          if (isMobile) updateDots(state);
        });
      };

      states.forEach((state) => {
        let ticking = false;
        state.track.addEventListener(
          "scroll",
          () => {
            if (ticking) return;
            ticking = true;
            window.requestAnimationFrame(() => {
              updateDots(state);
              ticking = false;
            });
          },
          { passive: true }
        );
      });

      mobileQuery.addEventListener("change", syncVisibility);
      window.addEventListener("resize", syncVisibility);
      syncVisibility();
    }
  }
}

{
  const demoVideos = Array.from(document.querySelectorAll("[data-case-study-demo-video]"));

  if (demoVideos.length > 0) {
    const motionQuery = window.matchMedia("(prefers-reduced-motion: reduce)");
    let reducedMotion = motionQuery.matches;

    const syncPausedState = (video) => {
      const frame = video.closest(".case-study-sendmoi-video-frame");
      video.classList.toggle("is-paused", video.paused);
      if (frame) {
        frame.classList.toggle("is-paused", video.paused);
      }
    };

    const playDemo = (video) => {
      const playback = video.play();
      if (playback && typeof playback.catch === "function") {
        playback.catch(() => {});
      }
    };

    const toggleDemoPlayback = (video) => {
      if (video.paused) {
        playDemo(video);
        return;
      }

      video.pause();
    };

    demoVideos.forEach((video) => {
      video.addEventListener("play", () => syncPausedState(video));
      video.addEventListener("pause", () => syncPausedState(video));
      video.addEventListener("click", () => toggleDemoPlayback(video));
      video.addEventListener("keydown", (event) => {
        if (event.key !== " " && event.key !== "Enter") {
          return;
        }

        event.preventDefault();
        toggleDemoPlayback(video);
      });

      if (!reducedMotion) {
        playDemo(video);
      }

      syncPausedState(video);
    });

    motionQuery.addEventListener("change", (event) => {
      reducedMotion = event.matches;

      demoVideos.forEach((video) => {
        if (reducedMotion) {
          if (!video.paused) {
            video.pause();
          }
          return;
        }

        if (video.paused && video.currentTime === 0) {
          playDemo(video);
        }
      });
    });
  }
}

if (themeToggles.length > 0) {
  const applyTheme = (theme, persist = true) => {
    const nextTheme = theme === "light" ? "light" : "dark";
    const isLight = nextTheme === "light";
    document.documentElement.dataset.theme = nextTheme;
    document.documentElement.style.colorScheme = nextTheme;

    if (themeColorMeta) {
      themeColorMeta.setAttribute("content", isLight ? LIGHT_THEME_COLOR : DARK_THEME_COLOR);
    }
    if (colorSchemeMeta) {
      colorSchemeMeta.setAttribute("content", nextTheme);
    }

    themeToggles.forEach((toggle) => {
      toggle.classList.toggle("is-on", isLight);
      toggle.classList.toggle("is-off", !isLight);
      toggle.setAttribute("aria-pressed", String(isLight));
      toggle.setAttribute(
        "aria-label",
        isLight ? "Switch to dark mode" : "Switch to light mode"
      );
      const state = toggle.querySelector(".theme-toggle-state");
      if (state) state.textContent = isLight ? "On" : "Off";
    });

    if (persist) {
      try {
        window.localStorage.setItem(THEME_STORAGE_KEY, nextTheme);
      } catch (error) {
        // Ignore storage access failures (privacy mode, browser restrictions).
      }
    }
  };

  let theme = "dark";
  try {
    const storedTheme = window.localStorage.getItem(THEME_STORAGE_KEY);
    if (storedTheme === "light") theme = "light";
  } catch (error) {
    // Ignore storage access failures and keep the dark default.
  }

  applyTheme(theme, false);
  themeToggles.forEach((toggle) => {
    toggle.addEventListener("click", () => {
      const isLight = document.documentElement.dataset.theme === "light";
      applyTheme(isLight ? "dark" : "light");
    });
  });
}

if (colsToggles.length > 0) {
  const applyGridVisibility = (visible, persist = true) => {
    document.documentElement.dataset.grid = visible ? "visible" : "hidden";
    document.body.classList.toggle("grid-hidden", !visible);
    colsToggles.forEach((toggle) => {
      toggle.classList.toggle("is-on", visible);
      toggle.classList.toggle("is-off", !visible);
      toggle.setAttribute("aria-pressed", String(visible));
      toggle.setAttribute(
        "aria-label",
        visible ? "Hide column grid" : "Show column grid"
      );
      const state = toggle.querySelector(".cols-toggle-state");
      if (state) state.textContent = visible ? "On" : "Off";
    });

    if (persist) {
      try {
        window.localStorage.setItem(COLS_TOGGLE_STORAGE_KEY, visible ? "1" : "0");
      } catch (error) {
        // Ignore storage access failures (privacy mode, browser restrictions).
      }
    }
  };

  let isVisible = false;
  try {
    const stored = window.localStorage.getItem(COLS_TOGGLE_STORAGE_KEY);
    if (stored === "0") isVisible = false;
    if (stored === "1") isVisible = true;
  } catch (error) {
    // Ignore storage access failures and keep the default hidden state.
  }

  applyGridVisibility(isVisible, false);
  colsToggles.forEach((toggle) => {
    toggle.addEventListener("click", () => {
      applyGridVisibility(document.body.classList.contains("grid-hidden"));
    });
  });
}

if (homeRailNav) {
  const lockTargetSelector = homeRailNav.dataset.lockTarget || "#work-experience";
  const lockTarget = document.querySelector(lockTargetSelector);
  let lockTop = 140;
  const getPageTop = (element) =>
    Math.round(element.getBoundingClientRect().top + window.scrollY);

  const updateLockTop = () => {
    const safeTopRaw = getComputedStyle(document.documentElement).getPropertyValue("--safe-top");
    const safeTop = Number.parseFloat(safeTopRaw);
    lockTop = 140 + (Number.isFinite(safeTop) ? safeTop : 0);
  };

  const setLockStart = () => {
    updateLockTop();
    const lockStart = lockTarget
      ? getPageTop(lockTarget)
      : Number(homeRailNav.dataset.navLockStart || 1049);
    homeRailNav.dataset.lockStartComputed = String(lockStart);
    homeRailNav.style.setProperty("--global-nav-start", `${lockStart}px`);
  };

  const updateHomeRailLock = () => {
    const lockStart = Number(
      homeRailNav.dataset.lockStartComputed || homeRailNav.dataset.navLockStart || 1049
    );

    if (window.innerWidth <= 959) {
      homeRailNav.classList.remove("is-locked");
      return;
    }

    const shouldLock = window.scrollY + lockTop >= lockStart;
    homeRailNav.classList.toggle("is-locked", shouldLock);
  };

  setLockStart();
  updateHomeRailLock();
  window.addEventListener("scroll", updateHomeRailLock, { passive: true });
  window.addEventListener("resize", () => {
    setLockStart();
    updateHomeRailLock();
  });
}

{
  const styleguideNav = document.querySelector(".styleguide-side-nav");

  if (styleguideNav) {
    const anchors = Array.from(styleguideNav.querySelectorAll(".styleguide-anchor"));
    const getPageTop = (element) =>
      Math.round(element.getBoundingClientRect().top + window.scrollY);
    const sections = anchors
      .map((anchor) => {
        const href = anchor.getAttribute("href");
        return href ? document.querySelector(href) : null;
      })
      .filter(Boolean);

    const setActiveAnchor = (activeIndex) => {
      anchors.forEach((anchor, index) => {
        const isActive = index === activeIndex;
        anchor.classList.toggle("is-active", isActive);
        if (isActive) {
          anchor.setAttribute("aria-current", "true");
        } else {
          anchor.removeAttribute("aria-current");
        }
      });
    };

    const updateStyleguideNav = () => {
      const activationLine = window.scrollY + 240;
      let activeIndex = -1;

      for (let i = 0; i < sections.length; i += 1) {
        if (activationLine >= getPageTop(sections[i])) {
          activeIndex = i;
        }
      }

      setActiveAnchor(activeIndex);
    };

    anchors.forEach((anchor, index) => {
      anchor.addEventListener("click", () => {
        setActiveAnchor(index);
      });
    });

    updateStyleguideNav();
    window.addEventListener("scroll", updateStyleguideNav, { passive: true });
    window.addEventListener("resize", updateStyleguideNav);
    window.addEventListener("hashchange", updateStyleguideNav);
  }
}

if (topLogoLinks.length > 0) {
  topLogoLinks.forEach((link) => {
    link.addEventListener("click", (event) => {
      event.preventDefault();
      scrollToPageTop();
    });
  });
}

{
  const body = document.body;
  const isCoarsePointer = window.matchMedia("(pointer: coarse)").matches;

  if (body && isCoarsePointer) {
    let startY = 0;
    let pulling = false;

    const clearPullingState = () => {
      if (!pulling) return;
      pulling = false;
      body.classList.remove("is-pulling-refresh");
    };

    window.addEventListener(
      "touchstart",
      (event) => {
        if (event.touches.length !== 1) return;
        startY = event.touches[0].clientY;
      },
      { passive: true }
    );

    window.addEventListener(
      "touchmove",
      (event) => {
        if (event.touches.length !== 1) return;
        const deltaY = event.touches[0].clientY - startY;
        const shouldHideMask = window.scrollY <= 0 && deltaY > 8;

        if (shouldHideMask && !pulling) {
          pulling = true;
          body.classList.add("is-pulling-refresh");
          return;
        }

        if (!shouldHideMask) {
          clearPullingState();
        }
      },
      { passive: true }
    );

    window.addEventListener("touchend", clearPullingState, { passive: true });
    window.addEventListener("touchcancel", clearPullingState, { passive: true });
    window.addEventListener(
      "scroll",
      () => {
        if (window.scrollY > 0) clearPullingState();
      },
      { passive: true }
    );
  }
}

if (logoMarks.length > 0) {
  const baseRotationDeg = -72.79;
  const rotationRate = 0.08;
  let ticking = false;

  const updateLogoRotation = () => {
    const rotation = baseRotationDeg + window.scrollY * rotationRate;
    logoMarks.forEach((mark) => {
      mark.style.transform = `rotate(${rotation}deg)`;
    });
    ticking = false;
  };

  window.addEventListener(
    "scroll",
    () => {
      if (!ticking) {
        window.requestAnimationFrame(updateLogoRotation);
        ticking = true;
      }
    },
    { passive: true }
  );
}

const visualCarousels = Array.from(document.querySelectorAll(".case-visual[data-carousel]"));
const lightbox = document.querySelector(".lightbox");

if (visualCarousels.length > 0) {
  const attachSwipe = (target, onPrev, onNext, options = {}) => {
    if (!target) return;
    const suppressClick = Boolean(options.suppressClick);
    let pointerId = null;
    let startX = 0;
    let startY = 0;
    let dragging = false;
    let swiped = false;
    const minDistance = 42;
    const maxVerticalDrift = 56;

    target.addEventListener("pointerdown", (event) => {
      if (event.pointerType === "mouse" && event.button !== 0) return;
      pointerId = event.pointerId;
      startX = event.clientX;
      startY = event.clientY;
      dragging = true;
    });

    target.addEventListener("pointerup", (event) => {
      if (!dragging || event.pointerId !== pointerId) return;
      const deltaX = event.clientX - startX;
      const deltaY = Math.abs(event.clientY - startY);
      dragging = false;
      pointerId = null;

      if (deltaY > maxVerticalDrift || Math.abs(deltaX) < minDistance) return;
      swiped = true;
      if (deltaX > 0) onPrev();
      if (deltaX < 0) onNext();
    });

    target.addEventListener("pointercancel", () => {
      dragging = false;
      pointerId = null;
    });

    if (suppressClick) {
      target.addEventListener(
        "click",
        (event) => {
          if (!swiped) return;
          event.preventDefault();
          event.stopPropagation();
          swiped = false;
        },
        true
      );
    }
  };

  const carouselStates = visualCarousels
    .map((figure) => {
      const dataNode = figure.querySelector(".case-visual-data");
      if (!dataNode) return null;

      try {
        const slides = JSON.parse(dataNode.textContent || "[]");
        if (!Array.isArray(slides) || slides.length === 0) return null;

        const image = figure.querySelector(".case-visual-image");
        const fig = figure.querySelector(".case-visual-fig");
        const caption = figure.querySelector(".case-visual-caption");
        const figcaption = figure.querySelector("figcaption");
        const prev = figure.querySelector(".case-visual-nav.prev");
        const next = figure.querySelector(".case-visual-nav.next");
        const open = figure.querySelector(".case-visual-open");

        if (!image || !fig || !caption || !figcaption || !prev || !next || !open) return null;

        const pageDots = document.createElement("div");
        pageDots.className = "case-visual-page-dots";
        const pageDotNodes = slides.map((_, index) => {
          const dot = document.createElement("span");
          dot.className = "case-visual-page-dot";
          if (index === 0) dot.classList.add("is-active");
          dot.setAttribute("aria-hidden", "true");
          pageDots.appendChild(dot);
          return dot;
        });
        if (pageDotNodes.length < 2) pageDots.hidden = true;
        figcaption.prepend(pageDots);

        return {
          figure,
          section: figure.closest(".case-study"),
          slides,
          image,
          fig,
          caption,
          figcaption,
          prev,
          next,
          open,
          pageDots,
          pageDotNodes,
          index: 0,
        };
      } catch (error) {
        return null;
      }
    })
    .filter(Boolean);

  {
    let activeCaptionState = null;
    let captionTicking = false;

    const clearPinnedCaption = () => {
      if (activeCaptionState) {
        activeCaptionState.figcaption.classList.remove("is-viewport-pinned");
      }
      activeCaptionState = null;
      document.body.classList.remove("has-active-case-caption");
      document.documentElement.style.removeProperty("--case-caption-left");
      document.documentElement.style.removeProperty("--case-caption-width");
      document.documentElement.style.removeProperty("--case-caption-bottom");
    };

    const updatePinnedCaption = () => {
      captionTicking = false;

      if (window.innerWidth <= 1100) {
        clearPinnedCaption();
        return;
      }

      const ENGAGE_OFFSET = -8;
      const RELEASE_OFFSET = 16;
      const nextState = carouselStates.find((state) => {
        const visualRect = state.figure.getBoundingClientRect();
        const isActiveState = activeCaptionState === state;
        const isStickyEngaged = isActiveState
          ? visualRect.top <= RELEASE_OFFSET && visualRect.bottom > 0
          : visualRect.top <= ENGAGE_OFFSET && visualRect.bottom > 0;
        return isStickyEngaged;
      });

      if (!nextState) {
        clearPinnedCaption();
        return;
      }

      if (activeCaptionState && activeCaptionState !== nextState) {
        activeCaptionState.figcaption.classList.remove("is-viewport-pinned");
      }

      const visualRect = nextState.figure.getBoundingClientRect();
      document.body.classList.add("has-active-case-caption");
      document.documentElement.style.setProperty("--case-caption-left", `${Math.max(0, visualRect.left)}px`);
      document.documentElement.style.setProperty("--case-caption-width", `${Math.max(0, visualRect.width)}px`);
      document.documentElement.style.setProperty(
        "--case-caption-bottom",
        `${Math.max(0, window.innerHeight - visualRect.bottom)}px`
      );
      nextState.figcaption.classList.add("is-viewport-pinned");
      activeCaptionState = nextState;
    };

    const queuePinnedCaptionUpdate = () => {
      if (captionTicking) return;
      captionTicking = true;
      window.requestAnimationFrame(updatePinnedCaption);
    };

    window.addEventListener("scroll", queuePinnedCaptionUpdate, { passive: true });
    window.addEventListener("resize", queuePinnedCaptionUpdate);
    carouselStates.forEach((state) => {
      state.image.addEventListener("load", queuePinnedCaptionUpdate);
    });
    queuePinnedCaptionUpdate();
  }

  const applySlide = (state, index, animated) => {
    const nextIndex = Math.max(0, Math.min(index, state.slides.length - 1));
    const slide = state.slides[nextIndex];

    const updateSlideContent = () => {
      state.index = nextIndex;
      state.image.src = slide.src;
      state.image.alt = slide.alt || "";
      state.fig.textContent = slide.fig || "";
      state.caption.textContent = slide.caption || "";
      state.pageDotNodes?.forEach((dot, dotIndex) => {
        dot.classList.toggle("is-active", dotIndex === nextIndex);
      });
      state.prev.disabled = state.index === 0;
      state.next.disabled = state.index === state.slides.length - 1;
      state.prev.setAttribute("aria-disabled", String(state.prev.disabled));
      state.next.setAttribute("aria-disabled", String(state.next.disabled));
    };

    if (!animated) {
      updateSlideContent();
      return;
    }

    state.image.classList.add("is-fading");
    updateSlideContent();
    window.setTimeout(() => {
      state.image.classList.remove("is-fading");
    }, 140);
  };

  carouselStates.forEach((state) => {
    state.slides.slice(1).forEach((slide) => {
      const preload = new Image();
      preload.src = slide.src;
    });

    applySlide(state, 0, false);
    state.prev.addEventListener("click", (event) => {
      event.preventDefault();
      event.stopPropagation();
      applySlide(state, state.index - 1, true);
    });
    state.next.addEventListener("click", (event) => {
      event.preventDefault();
      event.stopPropagation();
      applySlide(state, state.index + 1, true);
    });
    attachSwipe(
      state.open,
      () => applySlide(state, state.index - 1, true),
      () => applySlide(state, state.index + 1, true),
      { suppressClick: true }
    );
  });

  if (lightbox) {
    const closeButton = lightbox.querySelector(".lightbox-close");
    const lbImage = lightbox.querySelector(".lightbox-image");
    const lbCaption = lightbox.querySelector(".lightbox-caption");
    const lbPrev = lightbox.querySelector(".lightbox-nav.prev");
    const lbNext = lightbox.querySelector(".lightbox-nav.next");
    let activeState = null;
    let lightboxIndex = 0;

    const updateLightbox = () => {
      if (!activeState || !lbImage || !lbCaption || !lbPrev || !lbNext) return;
      const slide = activeState.slides[lightboxIndex];
      lbImage.src = slide.src;
      lbImage.alt = slide.alt || "";
      lbCaption.textContent = `${slide.fig || ""} ${slide.caption || ""}`.trim();
      lbPrev.disabled = lightboxIndex === 0;
      lbNext.disabled = lightboxIndex === activeState.slides.length - 1;
    };

    const openLightbox = (state) => {
      activeState = state;
      lightboxIndex = state.index;
      lightbox.hidden = false;
      lightbox.setAttribute("aria-hidden", "false");
      document.body.style.overflow = "hidden";
      updateLightbox();
    };

    const closeLightbox = () => {
      lightbox.hidden = true;
      lightbox.setAttribute("aria-hidden", "true");
      document.body.style.overflow = "";
      activeState = null;
    };

    carouselStates.forEach((state) => {
      state.open.addEventListener("click", () => openLightbox(state));
    });

    closeButton?.addEventListener("click", closeLightbox);
    lbPrev?.addEventListener("click", () => {
      if (!activeState) return;
      lightboxIndex = Math.max(0, lightboxIndex - 1);
      updateLightbox();
      applySlide(activeState, lightboxIndex, false);
    });
    lbNext?.addEventListener("click", () => {
      if (!activeState) return;
      lightboxIndex = Math.min(activeState.slides.length - 1, lightboxIndex + 1);
      updateLightbox();
      applySlide(activeState, lightboxIndex, false);
    });

    attachSwipe(
      lbImage,
      () => {
        if (!lbPrev?.disabled) lbPrev?.click();
      },
      () => {
        if (!lbNext?.disabled) lbNext?.click();
      }
    );

    lightbox.addEventListener("click", (event) => {
      if (event.target === lightbox) {
        closeLightbox();
      }
    });

    window.addEventListener("keydown", (event) => {
      if (lightbox.hidden) return;
      if (event.key === "Escape") closeLightbox();
      if (event.key === "ArrowLeft" && !lbPrev?.disabled) lbPrev?.click();
      if (event.key === "ArrowRight" && !lbNext?.disabled) lbNext?.click();
    });
  }
}

// Mobile nav sentinel — keeps the homepage mobile nav in sync with the scroll-restored sentinel position
{
  const mobileNavSentinel = document.querySelector('.mobile-nav-sentinel');
  const mobileNav = document.querySelector('.mobile-nav');
  if (mobileNavSentinel && mobileNav) {
    let mobileNavTicking = false;

    const updateMobileNavVisibility = () => {
      mobileNavTicking = false;
      mobileNav.classList.toggle(
        'is-visible',
        mobileNavSentinel.getBoundingClientRect().top <= 0
      );
    };

    const queueMobileNavVisibility = () => {
      if (mobileNavTicking) return;
      mobileNavTicking = true;
      window.requestAnimationFrame(updateMobileNavVisibility);
    };

    new IntersectionObserver(queueMobileNavVisibility).observe(mobileNavSentinel);
    window.addEventListener('scroll', queueMobileNavVisibility, { passive: true });
    window.addEventListener('resize', queueMobileNavVisibility);
    window.addEventListener('load', queueMobileNavVisibility);
    window.addEventListener('pageshow', queueMobileNavVisibility);
    queueMobileNavVisibility();
    window.requestAnimationFrame(queueMobileNavVisibility);
  }
}
