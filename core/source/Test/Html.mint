/* This module provides functions for testing `Html` */
module Test.Html {
  /*
  Starts a test of an `Html` node.

    test {
      Test.Html.start(<div>"Content"</div>)
    }
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

  /*
  Tries to find an element matching the selector. If found it replaces the
  value of the context with it, if not it fails the test.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.find("div")
    }
  */
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

  /*
  Tries to find an element matching the selector (globally). If found it
  replaces the value of the context with it, if not it fails the test.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.findGlobally("body")
    }
  */
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

  /*
  Asserts the top position of the current element.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.assertTop(0)
    }
  */
  fun assertTop (
    context : Test.Context(Dom.Element),
    top : Number
  ) : Test.Context(Dom.Element) {
    Test.Context.assertOf(context, top,
      (element : Dom.Element) : Number { Dom.getDimensions(element).top })
  }

  /*
  Asserts the left position of the current element.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.assertLeft(0)
    }
  */
  fun assertLeft (
    context : Test.Context(Dom.Element),
    left : Number
  ) : Test.Context(Dom.Element) {
    Test.Context.assertOf(context, left,
      (element : Dom.Element) : Number { Dom.getDimensions(element).left })
  }

  /*
  Asserts the height of the current element.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.assertHeight(0)
    }
  */
  fun assertHeight (
    context : Test.Context(Dom.Element),
    height : Number
  ) : Test.Context(Dom.Element) {
    Test.Context.assertOf(context, height,
      (element : Dom.Element) : Number { Dom.getDimensions(element).height })
  }

  /*
  Asserts the width of the current element.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.assertWidth(0)
    }
  */
  fun assertWidth (
    context : Test.Context(Dom.Element),
    width : Number
  ) : Test.Context(Dom.Element) {
    Test.Context.assertOf(context, width,
      (element : Dom.Element) : Number { Dom.getDimensions(element).width })
  }

  /*
  Triggers a click event on the element that matches the selector.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.triggerClick("div")
    }
  */
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

  /*
  Triggers a mouse down event on the element that matches the selector.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.triggerMouseDown("div")
    }
  */
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

  /*
  Triggers a mouse move event on the element that matches the selector.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.triggerMouseMove("div")
    }
  */
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

  /*
  Triggers a mouse up event on the element that matches the selector.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.triggerMouseUp("div")
    }
  */
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

  /*
  Triggers a keydown event with the key on the element that the selector.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.triggerKeyDown("div", "A")
    }
  */
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

  /*
  Triggers a keyup event with the key on the element that matches the selector.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.triggerKeyUp("div", "A")
    }
  */
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

  /*
  Asserts the text of the element that matches the selector.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.assertTextOf("div", "Content")
    }
  */
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

  /*
  Asserts that the active element matches the selector.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.assertActiveElement("div")
    }
  */
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

  /*
  Asserts that there is an element that matches the selector.

    test {
      Test.Html.start(<div>"Content"</div>)
      |> Test.Html.assertElementExists("div")
    }
  */
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

  /*
  Asserts the value of a CSS property on the element that matches the selector.

    test {
      Test.Html.start(<div style="color:red;">"Content"</div>)
      |> Test.Html.assertCssOf("div", "color", "red")
    }
  */
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
