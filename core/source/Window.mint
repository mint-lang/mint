module Window {
  /*
  Adds a listener to the window and returns the function which
  removes this listener.

    listener =
      Window.addEventListener("click", true, (event : Html.Event) {
        Debug.log(event)
      })
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
  Adds a media query listener to the window and returns the function which
  removes this listener.

    listener =
      Window.addMediaQueryListener("(max-width: 320px)", (matches : Bool) {
        Debug.log(matches)
      })
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

  /*
  Shows the default alert popup of the browser with the given message.

  This function returns a promise but blocks execution until the popup is
  closed.

    Window.alert("Hello World!")
  */
  fun alert (message : String) : Promise(Void) {
    `
    new Promise((resolve, reject) => {
      window.alert(#{message})

      resolve()
    })
    `
  }

  /*
  Shows the default confirm popup of the browser with the given message.

  This function returns a promise but blocks execution until the popup is
  closed.

    Window.confirm("Are you ready?")
  */
  fun confirm (message : String) : Promise(Result(String, Void)) {
    `
    new Promise((resolve, reject) => {
      let result = window.confirm(#{message})

      if (result) {
        resolve(#{Result::Ok(`result`)})
      } else {
        reject(#{Result::Err("User cancelled!")})
      }
    })
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

  /*
  Returns the height of the window in pixels.

    Window.height() == 768
  */
  fun height : Number {
    `window.innerHeight`
  }

  /*
  Returns the windows URL as a string.

    Window.href() == "https://www.example.com"
  */
  fun href : String {
    `window.location.href`
  }

  /*
  Returns true if the given url is the same as the current url of the page.

    Window.isActiveURL("https://www.example.com")
  */
  fun isActiveURL (url : String) : Bool {
    let window =
      Window.url()

    let current =
      Url.parse(url)

    (window.hostname == current.hostname &&
      window.protocol == current.protocol &&
      window.origin == current.origin &&
      window.path == current.path &&
      window.host == current.host &&
      window.port == current.port)
  }

  /*
  Returns `true` if the given media query matches.

    Window.matchesMediaQuery("(max-width: 320px)")
  */
  fun matchesMediaQuery (query : String) : Bool {
    `window.matchMedia(#{query}).matches`
  }

  /*
  Navigates to the given URL.

    Window.navigate("https://www.example.com")
  */
  fun navigate (url : String) : Promise(Void) {
    `_navigate(#{url})`
  }

  /*
  Opens the given url in a new window.

    Window.open("https://www.google.com")
  */
  fun open (url : String) : Promise(Void) {
    `window.open(#{url})`
  }

  /*
  Shows the default prompt popup of the browser with the given message and
  value.

  This function returns the entered text as a `Maybe(String)` and blocks
  execution until the popup is closed. If the user cancelled the popup it
  returns `Maybe::Nothing`.

    case (Window.prompt("How old are you?")) {
      Maybe::Just(value) => Debug.log(value)
      Maybe::Nothing => Debug.log("User cancelled")
    }
  */
  fun prompt (label : String, current : String = "") : Promise(Maybe(String)) {
    `
    new Promise((resolve) => {
      let result = window.prompt(#{label}, #{current})

      if (result !== null) {
        resolve(#{Maybe::Just(`result`)})
      } else {
        resolve(#{Maybe::Nothing})
      }
    })
    `
  }

  /*
  Returns the scrollable height of the window in pixels.

    Window.scrollHeight() == 768
  */
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

  /*
  Returns the horizontal scroll position of the window in pixels.

    Window.scrollLeft() == 100
  */
  fun scrollLeft : Number {
    `window.pageXOffset`
  }

  /*
  Returns the vertical scroll position of the window in pixels.

    Window.scrollTop() == 100
  */
  fun scrollTop : Number {
    `window.pageYOffset`
  }

  /*
  Returns the scrollable width of the window in pixels.

    Window.scrollWidth() == 1024
  */
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

  /*
  Sets the vertical scroll position of the window in pixels.

    Window.setScrollLeft(100)
  */
  fun setScrollLeft (position : Number) : Promise(Void) {
    `window.scrollTo(#{position}, #{scrollLeft()})`
  }

  /*
  Sets the horizontal scroll position of the window in pixels.

    Window.setScrollTop(100)
  */
  fun setScrollTop (position : Number) : Promise(Void) {
    `window.scrollTo(#{scrollTop()}, #{position})`
  }

  /*
  Sets the windows title.

    Window.setTitle("New Title!")
  */
  fun setTitle (title : String) : Promise(Void) {
    `document.title = #{title}`
  }

  /*
  Sets the URL of the window without navigating to it.

    Window.setUrl("https://www.example.com")
  */
  fun setUrl (url : String) : Promise(Void) {
    `_navigate(#{url}, false)`
  }

  /*
  Returns the windows title.

    Window.title() == "Title!"
  */
  fun title : String {
    `document.title`
  }

  /*
  Triggers the hash location jump on the page.

  When a page loads and the current url has a hash `#anchor-name` the browser
  automatically jumps to the matching anchor tag `<a name="anchor-name">`, but
  this behavior does not happen when the history is manipulated.

  This function triggers that behavior.
  */
  fun triggerHashJump : Promise(Void) {
    `requestAnimationFrame(() => {
      if (window.location.hash) {
        window.location.href = window.location.hash
      }
    })
    `
  }

  /*
  Returns the current `Url` of the window.

    Window.url().host == "www.example.com"
  */
  fun url : Url {
    Url.parse(href())
  }

  /*
  Returns the width of the window in pixels.

    Window.width == 1024
  */
  fun width : Number {
    `window.innerWidth`
  }
}
