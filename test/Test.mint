module Array {
  fun isEmpty (a : Array(a)) : Bool {
    `!!a.length`
  }
}

module Spec.Context {
  fun from (subject : a) : Spec.Context(a) {
    `new SpecContext(subject)`
  }
}

module Spec.Html {
  fun run (context : Spec.Context(a)) : Promise(String, a) {
    `context.run()`
  }

  fun start (node : Html) : Spec.Context(DOM.Element) {
    `
    (() => {
      let fragment = document.createDocumentFragment()
      ReactDOM.render(node, fragment)
      return new SpecContext(fragment)
    })()
    `
  }

  fun click (selector : String, context : Spec.Context(DOM.Element)) : Spec.Context(DOM.Element) {
    `
    context.step((element) => {
      element.querySelector(selector).click()
      return element
    })
    `
  }

  fun assertText (selector : String, value : String, context : Spec.Context(DOM.Element)) : Spec.Context(DOM.Element) {
    `
    context.step((element) => {
      let text = element.querySelector(selector).textContent
      if (text == value) {
        return element
        } else {
          throw \`"${text}" != "${value}"\`
        }
    })
    `
  }
}

suite "Array.isEmpty" {
  test "returns false for non-empty" {
    Array.isEmpty(["a"]) == true
  }

  test "returns true for empty" {
    Array.isEmpty([]) == false
  }

  test "a" {
    with Spec.Html {
      <div>
        <a/>
      </div>
      |> start()
      |> assertText("a", "")
    }
  }
}
