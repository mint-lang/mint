/* Module for testing `Html` */
module Test.Html {
  /*
  Starts a test of an `Html` node.

    Test.Html.start(<div>"Content"</div>)
  */
  fun start (node : Html) : Test.Context(Dom.Element) {
    (`
    (() => {
      const root = document.createElement("div")
      document.body.appendChild(root)
      #{%testRender%}(#{node}, root)
      return new #{%testContext%}(root, () => {
        document.body.removeChild(root)
      })
    })()
    ` as Test.Context(Dom.Element))
    |> Test.Context.timeout(0)
  }

  fun find (
    context : Test.Context(Dom.Element),
    selector : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      const subject = element.querySelector(#{selector})

      if (!subject) {
        throw \`Could not find element with selector: ${#{selector}}\`
      }
      return subject
    })
    `
  }

  fun findGlobally (
    context : Test.Context(Dom.Element),
    selector : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      const subject = document.querySelector(#{selector})

      if (!subject) {
        throw \`Could not find element with selector: ${#{selector}}\`
      }
      return subject
    })
    `
  }

  fun assertTop (context : Test.Context(Dom.Element), top : Number) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      context,
      top,
      (element : Dom.Element) : Number { Dom.getDimensions(element).top })
  }

  fun assertLeft (context : Test.Context(Dom.Element), left : Number) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      context,
      left,
      (element : Dom.Element) : Number { Dom.getDimensions(element).left })
  }

  fun assertHeight (context : Test.Context(Dom.Element), height : Number) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      context,
      height,
      (element : Dom.Element) : Number { Dom.getDimensions(element).height })
  }

  fun assertWidth (context : Test.Context(Dom.Element), width : Number) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      context,
      width,
      (element : Dom.Element) : Number { Dom.getDimensions(element).width })
  }

  /* Triggers a click event on the element that matches the given selector. */
  fun triggerClick (
    context : Test.Context(Dom.Element),
    selector : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      element.querySelector(#{selector}).click()
      return element
    })
    `
  }

  /* Triggers a mouse down event on the element that matches the given selector. */
  fun triggerMouseDown (
    context : Test.Context(Dom.Element),
    selector : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      const event = document.createEvent("MouseEvents")
      event.initEvent("mousedown", true, true)
      element.querySelector(#{selector}).dispatchEvent(event)
      return element
    })
    `
  }

  /* Triggers a mouse move event on the element that matches the given selector. */
  fun triggerMouseMove (
    context : Test.Context(Dom.Element),
    selector : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      const event = document.createEvent("MouseEvents")
      event.initEvent("mousemove", true, true)
      element.querySelector(#{selector}).dispatchEvent(event)
      return element
    })
    `
  }

  /* Triggers a mouse up event on the element that matches the given selector. */
  fun triggerMouseUp (
    context : Test.Context(Dom.Element),
    selector : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      const event = document.createEvent("MouseEvents")
      event.initEvent("mouseup", true, true)
      element.querySelector(#{selector}).dispatchEvent(event)
      return element
    })
    `
  }

  /* Triggers a keydown event with the specified key on the element that matches the given selector. */
  fun triggerKeyDown (
    context : Test.Context(Dom.Element),
    selector : String,
    key : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      const event = new KeyboardEvent('keydown', { key: #{key} });
      element.querySelector(#{selector}).dispatchEvent(event)
      return element
    })
    `
  }

  /* Triggers a keyup event with the specified key on the element that matches the given selector. */
  fun triggerKeyUp (
    context : Test.Context(Dom.Element),
    selector : String,
    key : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      const event = new KeyboardEvent('keyup', { key: #{key} });
      element.querySelector(#{selector}).dispatchEvent(event)
      return element
    })
    `
  }

  /* Asserts the text of the element that matches the given selector. */
  fun assertTextOf (
    context : Test.Context(Dom.Element),
    selector : String,
    value : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      let text

      try {
        text = element.querySelector(#{selector}).textContent
      } catch (error) {
        throw \`Could not find element with selector: ${#{selector}}\`
      }

      if (!(text == #{value})) {
        throw \`Assertion failed: ${text} === ${#{value}}\`
      }
      return element
    })
    `
  }

  fun assertActiveElement (
    context : Test.Context(Dom.Element),
    selector : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      const subject = element.querySelector(#{selector})

      if (!subject) {
        throw \`Could not find element with selector: ${#{selector}}\`
      }
      if (subject != document.activeElement) {
        throw \`Element is not active\`
      }
      return subject
    })
    `
  }

  /* Asserts that there is an element that matches the given selector. */
  fun assertElementExists (
    context : Test.Context(Dom.Element),
    selector : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      const subject = element.querySelector(#{selector})

      if (!subject) {
        throw \`Could not find element with selector: ${#{selector}}\`
      }
      return element
    })
    `
  }

  /* Asserts the value of a CSS property on the element that matches the given selector. */
  fun assertCssOf (
    context : Test.Context(Dom.Element),
    selector : String,
    property : String,
    value : String
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      const subject = element.querySelector(#{selector})

      if (!subject) {
        throw \`Could not find element with selector: ${#{selector}}\`
      }

      const actual = getComputedStyle(subject)[#{property}]

      if (!(actual == #{value})) {
        throw \`Assertion failed: ${actual} === ${#{value}}\`
      }
      return element
    })
    `
  }
}
