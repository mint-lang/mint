/* Functions for working with the DOM. */
module Dom {
  /*
  Blurs the active element of the page.

    Dom.blurActiveElement()
  */
  fun blurActiveElement : Promise(Void) {
    `document.activeElement && document.activeElement.blur()`
  }

  /*
  Returns if the given element is in an element that matches the given
  selector.

    Dom.containedInSelector(Dom.getElementBySelector("div"), "body")
  */
  fun containedInSelector (element : Dom.Element, selector : String) : Bool {
    `
    (() => {
      for (let base of document.querySelectorAll(selector)) {
        if (base.contains(element)) {
          return true
        }
      }

      return false
    })()
    `
  }

  /*
  Returns if the given base element contains the given element.

    Dom.contains(body, div) == true
  */
  fun contains (base : Dom.Element, element : Dom.Element) : Bool {
    `#{base}.contains(#{element})`
  }

  /*
  Creates a new `Dom.Element` with the given tag.

    Dom.createElement("div")
  */
  fun createElement (tag : String) : Dom.Element {
    `document.createElement(#{tag})`
  }

  /*
  Tries to focus the given element (if exists) in the next 150 milliseconds.
  Fails silently if there is no element or if the element cannot be focused.

    "my-id"
    |> Dom.focus
    |> Dom.getElementById()
  */
  fun focus (maybeElement : Maybe(Dom.Element)) : Promise(Void) {
    if let Maybe.Just(element) = maybeElement {
      focusWhenVisible(element)
      Promise.resolve(void)
    }
  }

  /* Focuses the first focusable descendant of the given element. */
  fun focusFirst (element : Dom.Element) : Promise(Void) {
    element
    |> getFocusableElements
    |> Array.first
    |> focus
  }

  /*
  Tries to focus the given element in the next 150 milliseconds.

    "my-div"
    |> Dom.getElementById
    |> Dom.focusWhenVisible()
  */
  fun focusWhenVisible (element : Dom.Element) : Promise(Result(String, Void)) {
    `
    new Promise((resolve) => {
      let counter = 0

      let focus = () => {
        if (counter > 15) {
          resolve(#{Result.Err("Could not focus the element in 150ms. Is it visible?")})
        }

        #{element}.focus()

        if (document.activeElement != #{element}) {
          counter++
          setTimeout(focus, 10)
        } else {
          resolve(#{Result.Ok(void)})
        }
      }

      focus()
    })
    `
  }

  /*
  Returns the active (focused) element of the page.

    Dom.getActiveElement() == Dom.getElementBySelector("body")
  */
  fun getActiveElement : Maybe(Dom.Element) {
    `
    (() => {
      if (document.activeElement) {
        return #{Maybe.Just(`document.activeElement`)}
      } else {
        return #{Maybe.Nothing}
      }
    })()
    `
  }

  /*
  If the attribute is present, it will return its value on the given element.

    outcome =
      Dom.getElementById("my-div")

    case (outcome) {
      Maybe.Just(element) => Dom.getAttribute(element, "id") == "my-div"
      Maybe.Nothing => false
    }
  */
  fun getAttribute (element : Dom.Element, name : String) : Maybe(String) {
    `
    (() => {
      const value = #{element}.getAttribute(#{name})

      if (value === "") {
        return #{Maybe.Nothing}
      } else {
        return #{Maybe.Just(`value`)}
      }
    })()
    `
  }

  /*
  Returns all child elements of the given element.

    Dom.getChildren())
  */
  fun getChildren (element : Dom.Element) : Array(Dom.Element) {
    `[...#{element}.children]`
  }

  /*
  Returns the `clientHeight` of the given element.

    Dom.getClientHeight(div) == 200
  */
  fun getClientHeight (element : Dom.Element) : Number {
    `#{element}.clientHeight || 0`
  }

  /*
  Returns the `clientWidth` of the given element.

    Dom.getClientWidth(div) == 200
  */
  fun getClientWidth (element : Dom.Element) : Number {
    `#{element}.clientWidth || 0`
  }

  /*
  Returns the dimensions (BoundingClientRect) of a `Dom.Element`

    Dom.getDimensions(Dom.createElement("div")) = {
      bottom: 0,
      height: 0,
      width: 0,
      right: 0,
      left: 0,
      top: 0,
      x: 0,
      y: 0
    }
  */
  fun getDimensions (dom : Dom.Element) : Dom.Dimensions {
    `
    (() => {
      const rect = #{dom}.getBoundingClientRect()

      return #{{
        bottom: `rect.bottom`,
        height: `rect.height`,
        width: `rect.width`,
        right: `rect.right`,
        left: `rect.left`,
        top: `rect.top`,
        x: `rect.x`,
        y: `rect.y`
      }}
    })()
    `
  }

  /*
  Gets the element with the given id from anywhere in the page.

    Dom.getElementById("my-div")
  */
  fun getElementById (id : String) : Maybe(Dom.Element) {
    `
    (() => {
      let element = document.getElementById(#{id})

      if (element) {
        return #{Maybe.Just(`element`)}
      } else {
        return #{Maybe.Nothing}
      }
    })()
    `
  }

  /*
  Gets the first element to match the given selector from anywhere in the page.

    Dom.getElementBySelector("body section > p:first-child")
  */
  fun getElementBySelector (selector : String) : Maybe(Dom.Element) {
    `
    (() => {
      try {
        let element = document.querySelector(#{selector})

        if (element) {
          return #{Maybe.Just(`element`)}
        } else {
          return #{Maybe.Nothing}
        }
      } catch (error) {
        return #{Maybe.Nothing}
      }
    })()
    `
  }

  /*
  Gets the element from a point on the screen.

    Dom.getElementFromPoint(0, 0)
  */
  fun getElementFromPoint (left : Number, top : Number) : Maybe(Dom.Element) {
    `
    (() => {
      const element = document.elementFromPoint(#{left}, #{top})

      if (element) {
        return #{Maybe.Just(`element`)}
      } else {
        return #{Maybe.Nothing}
      }
    })()
    `
  }

  /*
  Gets all descendant elements of an element which are matching
  the given selector.

    Dom.getElementsBySelector(element, "a[name]")
  */
  fun getElementsBySelector (element : Dom.Element, selector : String) : Array(Dom.Element) {
    `Array.from(#{element}.querySelectorAll(#{selector}))`
  }

  /* Returns all focusable descendant elements. */
  fun getFocusableElements (element : Dom.Element) : Array(Dom.Element) {
    `
    (() => {
      // Save focused element.
      const focused = document.activeElement

      // Save scroll position.
      const scrollX = window.scrollX
      const scrollY = window.scrollY

      // Save the scroll position of each element.
      const scrollPositions =
        [...document.querySelectorAll("*")].reduce((memo, element) => {
          if (element.scrollHeight > 0 || element.scrollWidth > 0) {
            memo.set(element, [element.scrollLeft, element.scrollTop])
          }

          return memo
        }, new Map)

      // Gather the focusable elements by focusing them and comparing it
      // with the focused element.
      const foundElements =
        [...#{element}.querySelectorAll("*")].reduce((memo ,element) => {
          element.focus()

          if (document.activeElement == element && element.tabIndex !== -1) {
            memo.push(element)
          }

          return memo
        }, [])

      // Restore scroll positions and focus.
      for (let element in scrollPositions) {
        const [x, y] = scrollPositions[element]
        element.scrollTo(x, y)
      }

      window.scrollTo(scrollX, scrollY)
      focused.focus()

      return foundElements
    })()
    `
  }

  /*
  Returns the scrollable height of the given element.

    Dom.getScrollHeight(div) == 0
  */
  fun getScrollHeight (element : Dom.Element) : Number {
    `#{element}.scrollHeight || 0`
  }

  /*
  Returns the horizontal scroll position of the given element.

    Dom.getScrollLeft(div) == 0
  */
  fun getScrollLeft (element : Dom.Element) : Number {
    `#{element}.scrollLeft || 0`
  }

  /*
  Returns the vertical scroll position of the given element.

    Dom.getScrollTop(div) == 0
  */
  fun getScrollTop (element : Dom.Element) : Number {
    `#{element}.scrollTop || 0`
  }

  /*
  Returns the scrollable width of the given element.

    Dom.getScrollWidth(div) == 300
  */
  fun getScrollWidth (element : Dom.Element) : Number {
    `#{element}.scrollWidth || 0`
  }

  /*
  Returns the table of contents of the given element for the given selectors.

    Dom.getTableOfContents(element, "h1, h2, h3, h4") == [
      {"h1", "The title of the page", "the-title-of-the-page"},
      {"h2", "A subtitle of the page", "a-subtitle-of-the-page"},
      {"h3", "A sub-subtitle of the page", "a-sub-subtitle-of-the-page"}
    ]
  */
  fun getTableOfContents (element : Dom.Element, selector : String) : Array(Tuple(String, String, String)) {
    element
    |> getElementsBySelector(selector)
    |> Array.map(
      (item : Dom.Element) : Tuple(String, String, String) {
        let tag =
          item
          |> getTagName()
          |> String.toLowerCase()

        let text =
          getTextContent(item)

        let hash =
          String.parameterize(text)

        {tag, text, hash}
      })
  }

  /*
  Returns the tagname of the given element.

    ("body"
    |> Dom.getElementBySelector("body")
    |> Dom.getTagName) == "BODY"
  */
  fun getTagName (element : Dom.Element) : String {
    `#{element}.tagName`
  }

  /*
  Returns the text content of the given element.

    Dom.getTextContent(Dom.getElementBySelector("body"))
  */
  fun getTextContent (element : Dom.Element) : String {
    `#{element}.textContent`
  }

  /*
  Measures the given text width with the given font using the canvas.

    Dom.getTextWidth("Hello There", "20px sans-serif") = 300
  */
  fun getTextWidth (text : String, font : String) : Number {
    `
    (() => {
      const canvas = document.createElement('canvas');
      const context = canvas.getContext("2d");

      context.font = #{font};

      return context.measureText(#{text}).width
    })()
    `
  }

  /*
  Gets the value as string form a `Dom.Element`.

  If the element supports value it will return it, otherwise it returns an
  empty string.

    Dom.getValue("input[value=hello]") == "hello"
    Dom.getValue("div") == ""
  */
  fun getValue (dom : Dom.Element) : String {
    `
    (() => {
      let value = #{dom}.value

      if (typeof value === "string") {
        return value
      } else {
        return ""
      }
    })()
    `
  }

  /*
  Returns whether or not the given `Dom.Element` matches the given selector.

    Dom.matches(Dom.createElement("div"), "div") == true
    Dom.matches(Dom.createElement("div"), "p") == false
  */
  fun matches (dom : Dom.Element, selector : String) : Bool {
    `
    (() => {
      try {
        return #{dom}.matches(#{selector})
      } catch (error) {
        return false
      }
    })()
    `
  }

  /*
  Scrolls the given element to the given position.

    Dom.scrollTo(element, 10, 10)
  */
  fun scrollTo (element : Dom.Element, left : Number, top : Number) : Promise(Void) {
    `#{element}.scrollTo({ left: #{left}, top: #{top} })`
  }

  /*
  Sets the given attribute to the given value of the given element and
  returns the element.

    "a"
    |> Dom.createElement
    |> Dom.setAttribute("name", "test")
  */
  fun setAttribute (
    element : Dom.Element,
    attribute : String,
    value : String
  ) : Dom.Element {
    `#{element}.setAttribute(#{attribute}, #{value}) && element`
  }

  /*
  Sets the given style to the given value of the given element.

    "my-div"
    |> Dom.getElementById()
    |> Dom.setStyle("background", "red")
    |> Dom.setStyle("color", "white")
  */
  fun setStyle (element : Dom.Element, name : String, value : String) : Dom.Element {
    `
    (() => {
      #{element}.style[#{name}] = #{value}
      return #{element}
    })()
    `
  }

  /*
  Sets the value property of a `Dom.Element`.

  It is used to set the value of `input` fields programmatically.
  */
  fun setValue (element : Dom.Element, value : String) : Dom.Element {
    `
    (() => {
      #{element}.value = #{value}
      return #{element}
    })()
    `
  }

  /*
  Smooth scroll the given element to the given position.

    Dom.smoothScrollTo(element, 10, 10)
  */
  fun smoothScrollTo (element : Dom.Element, left : Number, top : Number) : Promise(Void) {
    `#{element}.scrollTo({ behavior: 'smooth', left: #{left}, top: #{top} })`
  }
}
