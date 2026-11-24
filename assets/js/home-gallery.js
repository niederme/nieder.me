(() => {
  const dialog = document.querySelector(".project-gallery");
  const heading = dialog.querySelector("h2");
  const description = dialog.querySelector(".gallery-description");
  const images = dialog.querySelector(".gallery-images");
  const thumbs = dialog.querySelector(".gallery-thumbs");
  const counter = dialog.querySelector(".gallery-counter");
  const captions = dialog.querySelector(".gallery-caption p");
  const previous = dialog.querySelector(".gallery-prev");
  const next = dialog.querySelector(".gallery-next");
  const projectLinks = [...document.querySelectorAll("a[data-project]")];
  let slides = [];
  let index = 0;
  let opener;

  // Dialog autofocus and focus restoration can match :focus-visible after a touch.
  document.addEventListener("pointerdown", event => {
    if (event.target.closest(".project, .project-gallery")) {
      document.body.classList.add("gallery-pointer-input");
    }
  }, true);
  document.addEventListener("keydown", () => {
    document.body.classList.remove("gallery-pointer-input");
  }, true);

  function selectSlide(position) {
    if (position < 0 || position >= slides.length) return;
    index = position;
    slides.forEach(({ image, thumbnail, caption }, i) => {
      const selected = i === index;
      caption.classList.toggle("current", selected);
      if (image) {
        image.classList.toggle("current", selected);
        image.setAttribute("aria-hidden", String(!selected));
      }
      if (thumbnail) thumbnail.setAttribute("aria-current", String(selected));
    });
    counter.textContent = [index + 1, slides.length].map(n => String(n).padStart(2, "0")).join(" / ");
    previous.disabled = index === 0;
    next.disabled = index === slides.length - 1;
    const hash = index === 0 ? opener.hash : opener.hash + "/" + (index + 1);
    if (location.hash !== hash) history.replaceState(history.state, "", hash);
  }

  function openGallery(link) {
    const content = document.getElementById("gallery-" + link.dataset.project).content.cloneNode(true);
    const icon = link.querySelector(".project-icon");
    const name = link.querySelector("strong").firstChild.textContent.trim();
    opener = link;
    heading.replaceChildren(icon.cloneNode(true), link.dataset.galleryTitle || name);
    description.replaceChildren(content.querySelector(".gallery-info"));
    images.replaceChildren();
    thumbs.replaceChildren();
    captions.replaceChildren();
    const figures = [...content.querySelectorAll("figure")];
    slides = figures.map((figure, i) => {
      const image = figure.querySelector("img");
      const caption = document.createElement("span");
      caption.append(...figure.querySelector("figcaption").childNodes);
      captions.append(caption);
      let thumbnail;
      if (image) {
        images.append(image);
        if (figures.length > 1) {
          thumbnail = document.createElement("button");
          thumbnail.type = "button";
          thumbnail.setAttribute("aria-label", "Image " + (i + 1) + ". " + image.alt);
          const preview = image.cloneNode();
          preview.alt = "";
          thumbnail.append(preview);
          thumbnail.addEventListener("click", () => selectSlide(i));
          thumbs.append(thumbnail);
        }
      } else {
        images.append(icon.cloneNode(true));
      }
      return { image, caption, thumbnail };
    });
    thumbs.hidden = slides.length === 1;
    if (!dialog.open) dialog.showModal();
    dialog.scrollTop = 0;
    dialog.querySelector(".gallery-sidebar").scrollTop = 0;
  }

  function syncGallery() {
    const route = location.hash.match(/^(#gallery\/[\w-]+)(?:\/(\d+))?$/);
    const link = projectLinks.find(link => link.hash === route?.[1]);
    if (link) {
      if (!dialog.open || opener !== link) openGallery(link);
      const number = Math.max(1, Math.min(slides.length, Number(route[2] || 1)));
      selectSlide(number - 1);
    } else if (dialog.open) {
      dialog.close();
    }
  }

  function closeGallery() {
    if (history.state?.galleryFromHome === opener.hash) {
      history.back();
    } else {
      // A direct gallery visit has no homepage entry to go back to.
      history.replaceState(history.state, "", location.pathname + location.search);
      syncGallery();
    }
  }

  projectLinks.forEach(link => {
    link.addEventListener("click", event => {
      if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
      event.preventDefault();
      history.pushState({ galleryFromHome: link.hash }, "", link.hash);
      syncGallery();
    });
  });
  window.addEventListener("hashchange", syncGallery);
  window.addEventListener("pageshow", syncGallery);
  syncGallery();
  previous.addEventListener("click", () => selectSlide(index - 1));
  next.addEventListener("click", () => selectSlide(index + 1));
  dialog.querySelector(".gallery-close").addEventListener("click", closeGallery);
  dialog.addEventListener("cancel", event => {
    event.preventDefault();
    closeGallery();
  });
  dialog.addEventListener("keydown", event => {
    if (event.altKey || event.metaKey || event.ctrlKey) return;
    if (event.key === "ArrowLeft" || event.key === "ArrowRight") {
      event.preventDefault();
      selectSlide(index + (event.key === "ArrowLeft" ? -1 : 1));
    }
  });
  function outsideDialog(event) {
    const rect = dialog.getBoundingClientRect();
    return event.clientX < rect.left || event.clientX > rect.right ||
      event.clientY < rect.top || event.clientY > rect.bottom;
  }
  let pressedBackdrop = false;
  dialog.addEventListener("pointerdown", event => { pressedBackdrop = outsideDialog(event); });
  dialog.addEventListener("click", event => {
    if (pressedBackdrop && outsideDialog(event)) closeGallery();
    pressedBackdrop = false;
  });

  let swipeStart = null;
  // Only claim downward drags on the image. Text and thumbnail panes scroll natively.
  dialog.addEventListener("touchstart", event => {
    swipeStart = null;
    if (event.touches.length !== 1 || !images.contains(event.target) || dialog.scrollTop > 1) return;
    const touch = event.touches[0];
    swipeStart = { x: touch.clientX, y: touch.clientY };
  }, { passive: true });
  dialog.addEventListener("touchmove", event => {
    if (!swipeStart) return;
    const touch = event.touches[0];
    const dx = Math.abs(touch.clientX - swipeStart.x);
    const dy = touch.clientY - swipeStart.y;
    if (Math.max(dx, Math.abs(dy)) < 8) return;
    if (dy < dx * 1.5 || !event.cancelable) {
      swipeStart = null;
      return;
    }
    event.preventDefault();
  }, { passive: false });
  dialog.addEventListener("touchend", event => {
    if (!swipeStart) return;
    const touch = event.changedTouches[0];
    const dy = touch.clientY - swipeStart.y;
    if (dy >= 72 && dy > 1.5 * Math.abs(touch.clientX - swipeStart.x)) closeGallery();
    swipeStart = null;
  }, { passive: true });
  dialog.addEventListener("touchcancel", () => { swipeStart = null; });
  dialog.addEventListener("close", () => {
    swipeStart = null;
    opener?.focus({ preventScroll: true });
  });
})();
