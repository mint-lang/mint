hljs.configure({ languages: ["mint"] });
hljs.highlightAll();

document.getElementById("toc-mobile").addEventListener("click", (e) => {
  toc.classList.add("toc--open");
});

document.getElementById("toc").addEventListener("click", (e) => {
  toc.classList.remove("toc--open");
});

document.getElementById("toc-wrapper").addEventListener("click", (e) => {
  e.stopPropagation();
});

document.getElementById("search").addEventListener("input", (e) => {
  const term = e.target.value.toLowerCase().trim();

  document
    .querySelectorAll(`[data-search]`)
    .forEach((el) => (el.style.display = "none"));
    
  if (term === "") {
    document
      .querySelectorAll(`[data-search-empty="true"]`)
      .forEach((el) => (el.style.display = ""));
  } else {
    document
      .querySelectorAll(`[data-search*="${term}"]`)
      .forEach((el) => (el.style.display = ""));
  }
});
