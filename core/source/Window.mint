module Window {
  /* Navigates to the given URL. */
  fun navigate (url : String) : Promise(Never, Void) {
    `_navigate(url)`
  }

  /* Sets the URL of the window without navigating to it. */
  fun setUrl (url : String) : Promise(Never, Void) {
    `_navigate(url, false)`
  }

  /* Returns the windows title. */
  fun title : String {
    `document.title`
  }

  /* Sets the windows title. */
  fun setTitle (title : String) : Promise(Never, Void) {
    `document.title = title`
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
    `window.scrollTo(#{scrollTop()}, position)`
  }

  /* Sets the vertical scroll position of the window in pixels. */
  fun setScrollLeft (position : Number) : Promise(Never, Void) {
    `window.scrollTo(position, #{scrollLeft()})`
  }

  /*
  Shows the default confirm popup of the browser with the given message.
  This function returns a promise but blocks execution until the popup is
  closed.
  */
  fun confirm (message : String) : Promise(String, Void) {
    `
    (() => {
      let result = window.confirm(message)

      if (result) {
        return result;
      } else {
        return Promise.reject("User cancelled!")
      }
    })()
    `
  }
}
