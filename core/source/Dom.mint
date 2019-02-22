/* Functions for working with the DOM. */
module Dom {
  /* Creates a new `Dom.Element` with the given tag. */
  fun createElement (tag : String) : Dom.Element {
    `document.createElement(tag)`
  }

  /*
  Gets the element with the given id from anywhere in the page.

    Dom.getElementById("my-div")
  */
  fun getElementById (id : String) : Maybe(Dom.Element) {
    `
    (() => {
      let element = document.getElementById(id)

      if (element) {
        return new Just(element)
      } else {
        return new Nothing()
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
        let element = document.querySelector(selector)

        if (element) {
          return new Just(element)
        } else {
          return new Nothing()
        }
      } catch (error) {
        return new Nothing()
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
      const rect = dom.getBoundingClientRect()

      return new Record({
        bottom: rect.bottom,
        height: rect.height,
        width: rect.width,
        right: rect.right,
        left: rect.left,
        top: rect.top,
        x: rect.x,
        y: rect.y
      })
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
      let value = dom.value

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
    `(dom.value = value) && dom`
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
        return dom.matches(selector)
      } catch (error) {
        return false
      }
    })()
    `
  }
}
