const caseNav = document.querySelector(".case-nav");
const logoMark = document.querySelector(".logo-mark");

if (caseNav) {
  const lockTop = 140;
  const lockTarget = document.querySelector("#resy-header");
  const anchors = Array.from(caseNav.querySelectorAll(".case-anchor"));
  const sections = anchors
    .map((anchor) => {
      const href = anchor.getAttribute("href");
      return href ? document.querySelector(href) : null;
    })
    .filter(Boolean);

  const setLockStart = () => {
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
