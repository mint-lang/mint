/* Module for testing `Html` */
module Test.Html {
  /*
  Starts a test of an `Html` node.

    Test.Html.start(<div><{ "Content" }></div>)
  */
  fun start (node : Html) : Test.Context(Dom.Element) {
    `
    (() => {
      const root = document.createElement("div")
      document.body.appendChild(root)
      ReactDOM.render(#{node}, root)
      return new TestContext(root, () => {
        ReactDOM.unmountComponentAtNode(root)
        document.body.removeChild(root)
      })
    })()
    `
  }

  fun find (
    selector : String,
    context : Test.Context(Dom.Element)
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
    selector : String,
    context : Test.Context(Dom.Element)
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

  fun assertTop (top : Number, context : Test.Context(Dom.Element)) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      top,
      (element : Dom.Element) : Number { Dom.getDimensions(element).top },
      context)
  }

  fun assertLeft (left : Number, context : Test.Context(Dom.Element)) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      left,
      (element : Dom.Element) : Number { Dom.getDimensions(element).left },
      context)
  }

  fun assertHeight (height : Number, context : Test.Context(Dom.Element)) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      height,
      (element : Dom.Element) : Number { Dom.getDimensions(element).height },
      context)
  }

  fun assertWidth (width : Number, context : Test.Context(Dom.Element)) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      width,
      (element : Dom.Element) : Number { Dom.getDimensions(element).width },
      context)
  }

  /* Triggers a click event on the element that matches the given selector. */
  fun triggerClick (
    selector : String,
    context : Test.Context(Dom.Element)
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
    selector : String,
    context : Test.Context(Dom.Element)
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
    selector : String,
    context : Test.Context(Dom.Element)
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
    selector : String,
    context : Test.Context(Dom.Element)
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

  /* Asserts the text of the element that matches the given selector. */
  fun assertTextOf (
    selector : String,
    value : String,
    context : Test.Context(Dom.Element)
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
    selector : String,
    context : Test.Context(Dom.Element)
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
    selector : String,
    context : Test.Context(Dom.Element)
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
    selector : String,
    property : String,
    value : String,
    context : Test.Context(Dom.Element)
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
