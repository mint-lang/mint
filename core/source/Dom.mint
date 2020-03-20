/* Functions for working with the DOM. */
module Dom {
  /*
  Creates a new `Dom.Element` with the given tag.

    Dom.createElement("div")
  */
  fun createElement (tag : String) : Dom.Element {
    `document.createElement(#{tag})`
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
        return #{Maybe::Just(`element`)}
      } else {
        return #{Maybe::Nothing}
      }
    })()
    `
  }

  /*
  Gets the element with the given id from anywhere in the page.

    Dom.getElementById("body section > p:first-child")
  */
  fun getElementBySelector (selector : String) : Maybe(Dom.Element) {
    `
    (() => {
      try {
        let element = document.querySelector(#{selector})

        if (element) {
          return #{Maybe::Just(`element`)}
        } else {
          return #{Maybe::Nothing}
        }
      } catch (error) {
        return #{Maybe::Nothing}
      }
    })()
    `
  }

  /*
  Returns the dimensions (BoundingClientRect) of a `Dom.Element`

    Dom.getDimensions(Dom.createElement("div")) = {
      bottom = 0,
      height = 0,
      width = 0,
      right = 0,
      left = 0,
      top = 0,
      x = 0,
      y = 0
    }
  */
  fun getDimensions (dom : Dom.Element) : Dom.Dimensions {
    `
    (() => {
      const rect = #{dom}.getBoundingClientRect()

      return #{{
        bottom = `rect.bottom`,
        height = `rect.height`,
        width = `rect.width`,
        right = `rect.right`,
        left = `rect.left`,
        top = `rect.top`,
        x = `rect.x`,
        y = `rect.y`
      }}
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
  Sets the value property of a `Dom.Element`.

  It is used to set the value of `input` fields programatically.
  */
  fun setValue (value : String, dom : Dom.Element) : Dom.Element {
    `(#{dom}.value = #{value}) && #{dom}`
  }

  /*
  Returns whether or not the given `Dom.Element` matches the given selector.

    Dom.matches("div", Dom.createElement("div")) == true
    Dom.matches("p", Dom.createElement("div")) == false
  */
  fun matches (selector : String, dom : Dom.Element) : Bool {
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
  Tries to focus the given element (if exists) in the next 150 milliseconds.
  Fails silently if there is no element or if the element cannot be focused.

    "my-id"
    |> Dom.focus
    |> Dom.getElementById()
  */
  fun focus (maybeElement : Maybe(Dom.Element)) : Promise(Never , Void) {
    case (maybeElement) {
      Maybe::Just element =>
        sequence {
          focusWhenVisible(element)

          Promise.never()
        } catch {
          Promise.never()
        }

      Maybe::Nothing =>
        Promise.never()
    }
  }

  /*
  Tries to focus the given element in the next 150 milliseconds.

    "my-div"
    |> Dom.getElementById
    |> Dom.focusWhenVisible()
  */
  fun focusWhenVisible (element : Dom.Element) : Promise(String, Void) {
    `
    new Promise((resolve, reject) => {
      let counter = 0

      let focus = () => {
        if (counter > 15) {
          reject('Could not focus the element in 150ms. Is it visible?')
        }

        #{element}.focus()

        if (document.activeElement != #{element}) {
          counter++
          setTimeout(focus, 10)
        } else {
          resolve(#{void})
        }
      }

      focus()
    })
    `
  }

  /*
  Returns if the given base element contains the given element.

    body =
      Dom.getElementBySelector("body")

    div =
      Dom.getElementBySelector("div")

    Dom.contains(div, body) == true
  */
  fun contains (element : Dom.Element, base : Dom.Element) : Bool {
    `#{base}.contains(#{element})`
  }

  /*
  Returns if the given element is in an element that matches the given
  selector.

    Dom.containedInSelector("body", Dom.getElementBySelector("div"))
  */
  fun containedInSelector (selector : String, element : Dom.Element) : Bool {
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
  Returns the content of the given attribute of the given element.

    "my-div"
    |> Dom.getElementById()
    |> Dom.getAttribute("id") == "my-div"
  */
  fun getAttribute (name : String, element : Dom.Element) : String {
    `element.getAttribute(name) || ""`
  }

  /*
  Sets the given style to the given value of the given element.

    "my-div"
    |> Dom.getElementById()
    |> Dom.setStyle("background", "red")
    |> Dom.setStyle("color", "white")
  */
  fun setStyle (name : String, value : String, element : Dom.Element) : Dom.Element {
    `
    (() => {
      #{element}.style[#{name}] = #{value}
      return #{element}
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
      const element = document.elementFromPoint(left, top)

      if (element) {
        return new Just(element)
      } else {
        return new Nothing()
      }
    })()
    `
  }
}
