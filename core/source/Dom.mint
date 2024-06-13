/*
This module provides functions for working with the [DOM].

[DOM]: https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model
*/
module Dom {
  /*
  Blurs the active element of the page.

    Dom.blurActiveElement()
  */
  fun blurActiveElement : Promise(Void) {
    `document.activeElement && document.activeElement.blur()`
  }

  /*
  Returns if the element is in an other element that matches the selector.

    if let Just(div) = Document.getElementBySelector("div") {
      Dom.containedInSelector(div, "body")
    }
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
  Returns if the base element contains the element.

    if let Just(div) =  Dom.getElementBySelector("div") {
      if let Just(body) = Dom.getElementBySelector("body") {
        Dom.contains(body, div)
      }
    }
  */
  fun contains (base : Dom.Element, element : Dom.Element) : Bool {
    `#{base}.contains(#{element})`
  }

  /*
  Creates a new `Dom.Element` using the tag.

    Dom.createElement("div")
  */
  fun createElement (tag : String) : Dom.Element {
    `document.createElement(#{tag})`
  }

  /*
  Tries to focus the given element (if exists) in the next 150 milliseconds.
  Fails silently if there is no element or if the element cannot be focused.

    Dom.focus(Dom.getElementBySelector("input"))
  */
  fun focus (maybeElement : Maybe(Dom.Element)) : Promise(Void) {
    if let Maybe.Just(element) = maybeElement {
      focusWhenVisible(element)
      Promise.resolve(void)
    }
  }

  /*
  Focuses the first focusable descendant of the element. Fails silently if
  there is no element.

    if let Just(body) = Document.getElementBySelector("body") {
      Dom.focusFirst(body)
    }
  */
  fun focusFirst (element : Dom.Element) : Promise(Void) {
    element
    |> getFocusableElements
    |> Array.first
    |> focus
  }

  /*
  Tries to focus the element in the next 150 milliseconds.

    if let Just(input) = Document.getElementBySelector("input") {
      Dom.focusWhenVisible(input)
    }
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
  If the attribute is present, it will return its value on the element.

    if let Just(element) = Dom.getElementById("my-div") {
      Dom.getAttribute(element, "id") == "my-div"
    }
  */
  fun getAttribute (element : Dom.Element, attribute : String) : Maybe(String) {
    `
    (() => {
      const value = #{element}.getAttribute(#{attribute})

      if (value === "") {
        return #{Maybe.Nothing}
      } else {
        return #{Maybe.Just(`value`)}
      }
    })()
    `
  }

  /*
  Returns all child elements of the element.

    if let Just(body) = Dom.getElementBySelector("body") {
      Dom.getChildren(body)
    }
  */
  fun getChildren (element : Dom.Element) : Array(Dom.Element) {
    `[...#{element}.children]`
  }

  /*
  Returns the `clientHeight` of the element.

    if let Just(div) = Dom.getElementBySelector("div") {
      Dom.getClientHeight(div) == 200
    }
  */
  fun getClientHeight (element : Dom.Element) : Number {
    `#{element}.clientHeight || 0`
  }

  /*
  Returns the `clientWidth` of the element.

    if let Just(div) = Dom.getElementBySelector("div") {
      Dom.getClientWidth(div) == 200
    }
  */
  fun getClientWidth (element : Dom.Element) : Number {
    `#{element}.clientWidth || 0`
  }

  /*
  Returns the dimensions (`BoundingClientRect`) of the element.

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
  fun getDimensions (element : Dom.Element) : Dom.Dimensions {
    `
    (() => {
      const rect = #{element}.getBoundingClientRect()

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
  Gets the element with the id from anywhere in the page.

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
  Gets the first element to match the selector from anywhere in the page.

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
  Gets all descendant elements of an element which are matching the selector.

    if let Just(body) = Dom.getElementBySelector("body") {
      Dom.getElementsBySelector(body, "a[name]")
    }
  */
  fun getElementsBySelector (element : Dom.Element, selector : String) : Array(Dom.Element) {
    `Array.from(#{element}.querySelectorAll(#{selector}))`
  }

  /*
  Returns all focusable descendant elements.

    if let Just(body) = Dom.getElementBySelector("body") {
      Dom.getFocusableElements(body)
    }
  */
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
  Returns the scrollable height of the element.

    if let Just(div) = Dom.getElementBySelector("div") {
      Dom.getScrollHeight(div) == 0
    }
  */
  fun getScrollHeight (element : Dom.Element) : Number {
    `#{element}.scrollHeight || 0`
  }

  /*
  Returns the horizontal scroll position of the element.

    if let Just(div) = Dom.getElementBySelector("div") {
      Dom.getScrollLeft(div) == 0
    }
  */
  fun getScrollLeft (element : Dom.Element) : Number {
    `#{element}.scrollLeft || 0`
  }

  /*
  Returns the vertical scroll position of the element.

    if let Just(div) = Dom.getElementBySelector("div") {
      Dom.getScrollTop(div) == 0
    }
  */
  fun getScrollTop (element : Dom.Element) : Number {
    `#{element}.scrollTop || 0`
  }

  /*
  Returns the scrollable width of the element.

    if let Just(div) = Dom.getElementBySelector("div") {
      Dom.getScrollWidth(div) == 300
    }
  */
  fun getScrollWidth (element : Dom.Element) : Number {
    `#{element}.scrollWidth || 0`
  }

  /*
  Returns the table of contents of the element for the selectors.

    if let Just(body) = Dom.getElementBySelector("body") {
      Dom.getTableOfContents(body, "h1, h2, h3, h4") == [
        {"h1", "The title of the page", "the-title-of-the-page"},
        {"h2", "A subtitle of the page", "a-subtitle-of-the-page"},
        {"h3", "A sub-subtitle of the page", "a-sub-subtitle-of-the-page"}
      ]
    }
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
  Returns the tagname of the element.

    if let Just(body) = Dom.getElementBySelector("body") {
      Dom.getTagName(body) == "BODY"
    }
  */
  fun getTagName (element : Dom.Element) : String {
    `#{element}.tagName`
  }

  /*
  Returns the text content of the element.

    if let Just(body) = Document.getElementBySelector("body") {
      Dom.getTextContent(body)
    }
  */
  fun getTextContent (element : Dom.Element) : String {
    `#{element}.textContent`
  }

  /*
  Measures width of the text with the font using the canvas.

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
  Gets the value as string form an element. If the element supports value
  it will return it, otherwise it returns an empty string.

    if let Just(input) = Document.getElementBySelector("input[value=hello]") {
      Dom.getValue(input) == "hello"
    }
  */
  fun getValue (element : Dom.Element) : String {
    `
    (() => {
      let value = #{element}.value

      if (typeof value === "string") {
        return value
      } else {
        return ""
      }
    })()
    `
  }

  /*
  Returns whether or not the element matches the selector.

    Dom.matches(Dom.createElement("div"), "div") == true
    Dom.matches(Dom.createElement("div"), "p") == false
  */
  fun matches (element : Dom.Element, selector : String) : Bool {
    `
    (() => {
      try {
        return #{element}.matches(#{selector})
      } catch (error) {
        return false
      }
    })()
    `
  }

  /*
  Scrolls the element to the position.

    if let Just(body) = Document.getElementBySelector("body") {
      Dom.scrollTo(body, 10, 10)
    }
  */
  fun scrollTo (element : Dom.Element, left : Number, top : Number) : Promise(Void) {
    `#{element}.scrollTo({ left: #{left}, top: #{top} })`
  }

  /*
  Sets the attribute to the value of the element and returns the element.

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
  Sets the style to the value of the element.

    if let Just(div) = Document.getElementBySelector("div") {
      div
      |> Dom.setStyle("background", "red")
      |> Dom.setStyle("color", "white")
    }
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
  Sets the value property of an element. It is used to set the value of `input`
  fields programmatically.

    if let Just(input) = Document.getElementBySelector("input") {
      Dom.setValue(input, "Hello World!")
    }
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

    if let Just(body) = Document.getElementBySelector("body") {
      Dom.smoothScrollTo(body, 10, 10)
    }
  */
  fun smoothScrollTo (element : Dom.Element, left : Number, top : Number) : Promise(Void) {
    `#{element}.scrollTo({ behavior: 'smooth', left: #{left}, top: #{top} })`
  }
}
