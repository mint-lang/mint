/*
This module provides functions for working with the [Intersection Observer Web
API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API).
*/
module IntersectionObserver {
  /*
  Unobserves all observed elements.

    IntersectionObserver.disconnect(observer)
  */
  fun disconnect (observer : IntersectionObserver) : IntersectionObserver {
    `#{observer}.disconnect() || #{observer}`
  }

  /*
  Creates a new intersection observer.

    IntersectionObserver.new("50px", 0.1,
      (intersectionRatio : Number) {
        if (intersectionRatio == 1) {
          Debug.log("Fully visible!")
        } else {
          Debug.log("Not fully visible!")
        }
      })
  */
  fun new (
    rootMargin : String,
    threshold : Number,
    callback : Function(Number, a)
  ) : IntersectionObserver {
    `
    (() => {
      return new IntersectionObserver((entries) => {
        entries.forEach((entry) => #{callback(`entry.intersectionRatio`)})
      }, {
        rootMargin: #{rootMargin},
        threshold: #{threshold}
      });
    })()
    `
  }

  /*
  Observes the element.

    if let Just(element) = Dom.getElementBySelector("div") {
      IntersectionObserver.observe(observer, element)
    }
  */
  fun observe (
    observer : IntersectionObserver,
    element : Dom.Element
  ) : IntersectionObserver {
    `#{observer}.observe(#{element}) || #{observer}`
  }

  /*
  Unobserves the element.

    if let Just(element) = Dom.getElementBySelector("div") {
      IntersectionObserver.unobserve(observer, element)
    }
  */
  fun unobserve (
    observer : IntersectionObserver,
    element : Dom.Element
  ) : IntersectionObserver {
    `#{observer}.unobserve(#{element}) || #{observer}`
  }
}
