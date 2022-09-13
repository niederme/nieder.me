//
// Le JavaScript
// --------------------------------------------------

// @codekit-prepend "jquery-3.5.1.min.js";

$(document).ready(function () {
  console.log("ready!");

  if ("CSS" in window && "supports" in window.CSS) {
    var support = window.CSS.supports("mix-blend-mode", "difference");
    // tests for mix-blend-mode support
    support = support ? "mix-blend-mode" : "no-mix-blend-mode";
    document.documentElement.className += support;
  }
});

// spin the logo on scroll
window.onscroll = function () {
  scrollRotate();
};

function scrollRotate() {
  let image = document.getElementById("logo");
  image.style.transform = "rotate(" + window.pageYOffset / 2 + "deg)";
}
