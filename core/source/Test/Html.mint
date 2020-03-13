/* Module for testing `Html` */
module Test.Html {
  /*
  Starts a test of an `Html` node.

    Test.Html.start(<div><{ "Content" }></div>)
  */
  start (node : Html) : Test.Context(Dom.Element) {
    `
    (() => {
      let root = document.createElement('div')
      document.body.appendChild(root)
      ReactDOM.render(#{node}, root)
      return new TestContext(root, () => {
        ReactDOM.unmountComponentAtNode(root)
        document.body.removeChild(root)
      })
    })()
    `
  }

  find (
    selector : String,
    context : Test.Context(Dom.Element)
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      let subject = element.querySelector(#{selector})

      if (subject) {
        return subject
      } else {
        throw \`Could not find element with selector: ${#{selector}}\`
      }
    })
    `
  }

  findGlobally (
    selector : String,
    context : Test.Context(Dom.Element)
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      let subject = document.querySelector(#{selector})

      if (subject) {
        return subject
      } else {
        throw \`Could not find element with selector: ${#{selector}}\`
      }
    })
    `
  }

  assertTop (top : Number, context : Test.Context(Dom.Element)) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      top,
      (element : Dom.Element) : Number {
        try {
          dimensions =
            Dom.getDimensions(element)

          dimensions.top
        }
      },
      context)
  }

  assertLeft (left : Number, context : Test.Context(Dom.Element)) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      left,
      (element : Dom.Element) : Number {
        try {
          dimensions =
            Dom.getDimensions(element)

          dimensions.left
        }
      },
      context)
  }

  assertHeight (height : Number, context : Test.Context(Dom.Element)) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      height,
      (element : Dom.Element) : Number {
        try {
          dimensions =
            Dom.getDimensions(element)

          dimensions.height
        }
      },
      context)
  }

  assertWidth (width : Number, context : Test.Context(Dom.Element)) : Test.Context(Dom.Element) {
    Test.Context.assertOf(
      width,
      (element : Dom.Element) : Number {
        try {
          dimensions =
            Dom.getDimensions(element)

          dimensions.width
        }
      },
      context)
  }

  /* Triggers a click event on the element that matches the given selector. */
  triggerClick (
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
  triggerMouseDown (
    selector : String,
    context : Test.Context(Dom.Element)
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      let event = document.createEvent ('MouseEvents')
      event.initEvent ("mousedown", true, true)
      element.querySelector(#{selector}).dispatchEvent(event)
      return element
    })
    `
  }

  /* Triggers a mouse move event on the element that matches the given selector. */
  triggerMouseMove (
    selector : String,
    context : Test.Context(Dom.Element)
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      let event = document.createEvent ('MouseEvents')
      event.initEvent ("mousemove", true, true)
      element.querySelector(#{selector}).dispatchEvent(event)
      return element
    })
    `
  }

  /* Triggers a mouse up event on the element that matches the given selector. */
  triggerMouseUp (
    selector : String,
    context : Test.Context(Dom.Element)
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      let event = document.createEvent ('MouseEvents')
      event.initEvent ("mouseup", true, true)
      element.querySelector(#{selector}).dispatchEvent(event)
      return element
    })
    `
  }

  /* Asserts the text of the element that matches the given selector. */
  assertTextOf (
    selector : String,
    value : String,
    context : Test.Context(Dom.Element)
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      let text = "";

      try {
        text = element.querySelector(#{selector}).textContent
      } catch (error) {
        throw \`Could not find element with selector: ${#{selector}}\`
      }

      if (text == #{value}) {
        return element
      } else {
        throw \`"${text}" != "${#{value}}"\`
      }
    })
    `
  }

  assertActiveElement (
    selector : String,
    context : Test.Context(Dom.Element)
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      let subject = element.querySelector(#{selector})

      if (subject) {
        if (subject == document.activeElement) {
          return subject
        }  else {
          throw \`Element is not active ${subject}\`
        }
      } else {
        throw \`Could not find element with selector: ${#{selector}}\`
      }
    })
    `
  }

  /* Asserts that there is an element that matches the given selector. */
  assertElementExists (
    selector : String,
    context : Test.Context(Dom.Element)
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      let subject = element.querySelector(#{selector})

      if (subject) {
        return element
      } else {
        throw \`Could not find element with selector: ${#{selector}}\`
      }
    })
    `
  }

  /* Asserts the value of a css property on the element that matches the given selector. */
  assertCSSOf (
    selector : String,
    property : String,
    value : String,
    context : Test.Context(Dom.Element)
  ) : Test.Context(Dom.Element) {
    `
    #{context}.step((element) => {
      let subject = element.querySelector(#{selector})

      if (subject) {
        let actual = getComputedStyle(subject)[#{property}]

        if (actual == #{value}) {
          return element
        } else {
          throw \`Style did not match expected "${#{value}}" got "${actual}"\`
        }
      } else {
        throw \`Could not find element with selector: ${#{selector}}\`
      }
    })
    `
  }
}
