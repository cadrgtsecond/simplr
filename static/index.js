function update_expand_next(el) {
  const toexpand = el.parentElement.nextElementSibling;
  console.log(toexpand)
  if(el.checked) {
    toexpand.style["display"] = "block";
  } else {
    toexpand.style["display"] = "none";
  }
}

for(el of document.querySelectorAll("[js-expandnext]")) {
  update_expand_next(el);
  el.addEventListener("input", ev => update_expand_next(ev.target))
}
