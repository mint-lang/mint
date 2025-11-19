/* A data structure for the mutation observers entry. */
type MutationObserver.Entry {
  target : Dom.Element,
  type : String
}

/*
This module provides functions for working with the [Mutation Observer Web API
](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver).
*/
module MutationObserver {
  /*
  Creates a new resize observer.

    MutationObserver.new((entries : MutationObserver.Entry) {
      for (entry of entries) {
        Debug.log(entry)
      }
    })
  */
  fun new (
    callback : Function(Array(MutationObserver.Entry), a)
  ) : MutationObserver {
    `new MutationObserver(#{callback})`
  }

  /*
  Observes the element.

    if let Just(element) = Dom.getElementBySelector("div") {
      MutationObserver.observe(observer, element, true, true)
    }
  */
  fun observe (
    observer : MutationObserver,
    element : Dom.Element,
    subtree : Bool,
    childList : Bool
  ) : MutationObserver {
    `
    #{observer}.observe(#{element}, {
      childList: #{childList},
      subtree: #{subtree}
    }) || #{observer}
    `
  }

  /*
  Unobserves the element.

    if let Just(element) = Dom.getElementBySelector("div") {
      MutationObserver.unobserve(observer, element)
    }
  */
  fun unobserve (
    observer : MutationObserver,
    element : Dom.Element
  ) : MutationObserver {
    `#{observer}.disconnect(#{element}) || #{observer}`
  }
}
