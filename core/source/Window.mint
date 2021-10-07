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
    `
    (() => {
      const body = document.body
      const html = document.documentElement

      return Math.max(
        body.scrollHeight, html.scrollHeight,
        body.offsetHeight, html.offsetHeight,
        body.clientHeight, html.clientHeight
      )
    })()
    `
  }

  /* Returns the scrollable width of the window in pixels. */
  fun scrollWidth : Number {
    `
    (() => {
      const body = document.body
      const html = document.documentElement

      return Math.max(
        body.scrollWidth, html.scrollWidth,
        body.offsetWidth, html.offsetWidth,
        body.clientWidth, html.clientWidth
      )
    })()
    `
  }

  /* Returns the horizontal scroll position of the window in pixels. */
  fun scrollLeft : Number {
    `window.pageXOffset`
  }

  /* Returns the vertical scroll position of the window in pixels. */
  fun scrollTop : Number {
    `window.pageYOffset`
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
  Shows the default alert popup of the browser with the given message.

  This function returns a promise but blocks execution until the popup is
  closed.
  */
  fun alert (message : String) : Promise(Never, Void) {
    `
    new Promise((resolve, reject) => {
      window.alert(#{message})

      resolve()
    })
    `
  }

  /* Returns true if the given url is the same as the current url of the page. */
  fun isActiveURL (url : String) : Bool {
    window =
      Window.url()

    current =
      Url.parse(url)

    (window.hostname == current.hostname &&
      window.protocol == current.protocol &&
      window.origin == current.origin &&
      window.path == current.path &&
      window.host == current.host &&
      window.port == current.port)
  }

  /*
  Triggers the hash location jump on the page.

  When a page loads and the current url has a hash `#anchor-name` the browser
  automatically jumps to the matching anchor tag `<a name="anchor-name">`, but
  this behavior does not happen when the history is manipulated.

  This function triggers that behavior.
  */
  fun triggerHashJump : Promise(Never, Void) {
    `requestAnimationFrame(() => {
      if (window.location.hash) {
        window.location.href = window.location.hash
      }
    })
    `
  }

  /*
  Opens the given url in a new window.

    Window.open("https://www.google.com")
  */
  fun open (url : String) : Promise(Never, Void) {
    `window.open(#{url})`
  }

  /*
  Adds a media query listener to the window and returns the function which
  removes this listener.
  */
  fun addMediaQueryListener (query : String, listener : Function(Bool, a)) : Function(Void) {
    `
    (() => {
      const query = window.matchMedia(#{query});
      const listener = (event) => #{listener}(query.matches);
      query.addListener(listener)
      #{listener}(query.matches)
      return () => query.removeListener(listener);
    })()
    `
  }

  /* Returns `true` if the given media query matches. */
  fun matchesMediaQuery (query : String) : Bool {
    `window.matchMedia(#{query}).matches`
  }

  /*
  Adds a listener to the window and returns the function which
  removes this listener.
  */
  fun addEventListener (
    type : String,
    capture : Bool,
    listener : Function(Html.Event, a)
  ) : Function(Void) {
    `
    (() => {
      const listener = (event) => {
        #{listener}(_normalizeEvent(event))
      }

      window.addEventListener(#{type}, listener, #{capture});
      return () => window.removeEventListener(#{type}, listener, #{capture});
    })()
    `
  }

  /*
  Gets the width of the scrollbar.

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
