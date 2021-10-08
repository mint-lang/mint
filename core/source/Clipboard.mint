/* This module has functions for manipulating the clipboard. */
module Clipboard {
  /* Sets the clipboards content to the given value. */
  fun set (value : String) : Promise(Void) {
    `
    (() => {
      // Create a textarea element
      const textarea = document.createElement("textarea");

      // Position it on the screen
      textarea.style.position = "fixed";
      textarea.style.left = "10px";
      textarea.style.top = "10px";
      textarea.style.opacity = 0;

      // Add it to the DOM
      document.body.appendChild(textarea)

      // Focus it and set value
      textarea.focus()
      textarea.value = #{value}

      // Create a selection range and set value
      const range = document.createRange();
      range.selectNodeContents(textarea);

      // Get selection and replace current selection
      const selection = window.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);

      // Select all the text
      textarea.setSelectionRange(0, 999999);

      // Copy to clipboard
      document.execCommand("copy");

      // Remove textarea from the DOM
      textarea.remove()
    })()
    `
  }
}
