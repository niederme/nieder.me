const caseNav = document.querySelector(".case-nav");
const logoMark = document.querySelector(".logo-mark");
const colsToggle = document.querySelector(".cols-toggle");
const colsToggleState = colsToggle?.querySelector(".cols-toggle-state");
const emailLink = document.querySelector("[data-email-link]");
const COLS_TOGGLE_STORAGE_KEY = "nieder.cols-grid-visible";

if (emailLink) {
  const emailAddress = String.fromCharCode(
    106, 111, 104, 110, 64, 110, 105, 101, 100, 101, 114, 46, 109, 101
  );
  emailLink.href = `mailto:${emailAddress}`;
}

if (colsToggle) {
  const applyGridVisibility = (visible, persist = true) => {
    document.body.classList.toggle("grid-hidden", !visible);
    colsToggle.classList.toggle("is-on", visible);
    colsToggle.classList.toggle("is-off", !visible);
    colsToggle.setAttribute("aria-pressed", String(visible));
    colsToggle.setAttribute(
      "aria-label",
      visible ? "Hide column grid" : "Show column grid"
    );
    if (colsToggleState) colsToggleState.textContent = visible ? "On" : "Off";

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
    // Ignore storage access failures and keep default hidden state.
  }

  applyGridVisibility(isVisible, false);
  colsToggle.addEventListener("click", () => {
    applyGridVisibility(document.body.classList.contains("grid-hidden"));
  });
}

if (caseNav) {
  const lockTarget = document.querySelector("#resy-header");
  const anchors = Array.from(caseNav.querySelectorAll(".case-anchor"));
  const topAnchor = anchors[0] || null;
  const sections = anchors
    .map((anchor) => {
      const href = anchor.getAttribute("href");
      return href ? document.querySelector(href) : null;
    })
    .filter(Boolean);
  let lockTop = 140;

  if (topAnchor) {
    topAnchor.addEventListener("click", (event) => {
      event.preventDefault();
      window.scrollTo({ top: 0, behavior: "smooth" });

      if (window.location.hash) {
        history.replaceState(
          null,
          "",
          `${window.location.pathname}${window.location.search}`
        );
      }
    });
  }

  const updateLockTop = () => {
    const safeTopRaw = getComputedStyle(document.documentElement).getPropertyValue("--safe-top");
    const safeTop = Number.parseFloat(safeTopRaw);
    lockTop = 140 + (Number.isFinite(safeTop) ? safeTop : 0);
  };

  const setLockStart = () => {
    updateLockTop();
    const lockStart = lockTarget
      ? Math.round(lockTarget.offsetTop)
      : Number(caseNav.dataset.lockStart || 1049);
    caseNav.dataset.lockStartComputed = String(lockStart);
    caseNav.style.setProperty("--case-nav-start", `${lockStart}px`);
  };

  const updateRailNav = () => {
    const lockStart = Number(
      caseNav.dataset.lockStartComputed || caseNav.dataset.lockStart || 1049
    );

    if (window.innerWidth <= 1100) {
      caseNav.classList.remove("is-locked");
      return;
    }

    const shouldLock = window.scrollY + lockTop >= lockStart;
    caseNav.classList.toggle("is-locked", shouldLock);

    let activeIndex = 0;
    for (let i = 0; i < sections.length; i += 1) {
      if (window.scrollY + 240 >= sections[i].offsetTop) {
        activeIndex = i;
      }
    }

    anchors.forEach((anchor, index) => {
      anchor.classList.toggle("is-active", index === activeIndex);
    });
  };

  setLockStart();
  window.addEventListener("scroll", updateRailNav, { passive: true });
  window.addEventListener("resize", () => {
    setLockStart();
    updateRailNav();
  });
  updateRailNav();
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

if (logoMark) {
  const baseRotationDeg = -72.79;
  const rotationRate = 0.08;
  let ticking = false;

  const updateLogoRotation = () => {
    const rotation = baseRotationDeg + window.scrollY * rotationRate;
    logoMark.style.transform = `rotate(${rotation}deg)`;
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
