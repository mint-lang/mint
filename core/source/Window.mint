module Window {
  /* Navigates to the given URL. */
  fun navigate (url : String) : Promise(Never, Void) {
    `_navigate(#{url})`
  }

  /* Sets the URL of the window without navigating to it. */
  fun setUrl (url : String) : Promise(Never, Void) {
    `_navigate(#{url}, false)`
  }

  /* Returns the windows title. */
  fun title : String {
    `document.title`
  }

  /* Sets the windows title. */
  fun setTitle (title : String) : Promise(Never, Void) {
    `document.title = #{title}`
  }

  /* Returns the current `Url` of the window. */
  fun url : Url {
    Url.parse(href())
  }

  /* Returns the windows URL as a string. */
  fun href : String {
    `window.location.href`
  }

  /* Returns the width of the window in pixels. */
  fun width : Number {
    `window.innerWidth`
  }

  /* Returns the height of the window in pixels. */
  fun height : Number {
    `window.innerHeight`
  }

  /* Returns the scrollable height of the window in pixels. */
  fun scrollHeight : Number {
    `document.body.scrollHeight`
  }

  /* Returns the scrollable width of the window in pixels. */
  fun scrollWidth : Number {
    `document.body.scrollWidth`
  }

  /* Returns the horizontal scroll position of the window in pixels. */
  fun scrollLeft : Number {
    `document.body.scrollLeft`
  }

  /* Returns the vertical scroll position of the window in pixels. */
  fun scrollTop : Number {
    `document.body.scrollTop`
  }

  /* Sets the horizontal scroll position of the window in pixels. */
  fun setScrollTop (position : Number) : Promise(Never, Void) {
    `window.scrollTo(#{scrollTop()}, #{position})`
  }

  /* Sets the vertical scroll position of the window in pixels. */
  fun setScrollLeft (position : Number) : Promise(Never, Void) {
    `window.scrollTo(#{position}, #{scrollLeft()})`
  }

  /*
  Shows the default prompt popup of the browser with the given message and
  value.

  This function returns a promise but blocks execution until the popup is
  closed.
  */

  fun prompt (label : String, current : String) : Promise(String, String) {
    `
    new Promise((resolve, reject) => {
      let result = window.prompt(#{label}, #{current})

      if (result) {
        resolve(result)
      } else {
        reject("User cancelled!")
      }
    })
    `
  }

  /*
  Shows the default confirm popup of the browser with the given message.

  This function returns a promise but blocks execution until the popup is
  closed.
  */
  fun confirm (message : String) : Promise(String, Void) {
    `
    new Promise((resolve, reject) => {
      let result = window.confirm(#{message})

      if (result) {
        resolve(result);
      } else {
        reject("User cancelled!")
      }
    })
    `
  }

  /*
  Opens the given url in a new window.

    Window.open("https://www.google.com")
  */
  fun open (url : String) : Promise(Never, Void) {
    `window.open(url)`
  }

  /*
  Gets the with of the scrollbar.

    Window.getScrollbarWidth() == 10
  */
  fun getScrollbarWidth : Number {
    `
    (() => {
      // Create an outer div which is scrollable
      const outer = document.createElement("div");

      // Set the needed styles
      outer.style.visibility = "hidden";
      outer.style.width = "100px";
      outer.style.msOverflowStyle = "scrollbar"; // needed for WinJS apps

      // Append it to the body
      document.body.appendChild(outer);

      const widthNoScroll = outer.offsetWidth;

      // Force scrollbars
      outer.style.overflow = "scroll";

      // Add innerdiv
      const inner = document.createElement("div");
      inner.style.width = "100%";
      outer.appendChild(inner);

      const widthWithScroll = inner.offsetWidth;

      // remove divs
      outer.parentNode.removeChild(outer);

      return widthNoScroll - widthWithScroll;
    })()
    `
  }
}
