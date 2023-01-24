/*
This module provides a wrapper for the Intersection Observer Web API [1].

[1] https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API
*/
module IntersectionObserver {
  /* Unobserves all observerd elements. */
  fun disconnect (observer : IntersectionObserver) : IntersectionObserver {
    `#{observer}.disconnect() || #{observer}`
  }

  /*
  Creates a new intersection observer.

    observer =
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
        entries.forEach((entry) => {
          #{callback(`entry.intersectionRatio`)}
        })
      }, {
        rootMargin: #{rootMargin},
        threshold: #{threshold}
      });
    })()
    `
  }

  /* Observes the given element. */
  fun observe (
    observer : IntersectionObserver,
    element : Dom.Element
  ) : IntersectionObserver {
    `#{observer}.observe(#{element}) || #{observer}`
  }

  /* Unobserves the given element. */
  fun unobserve (
    observer : IntersectionObserver,
    element : Dom.Element
  ) : IntersectionObserver {
    `#{observer}.unobserve(#{element}) || #{observer}`
  }
}
