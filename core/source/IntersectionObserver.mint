/* This module provides a wrapper for the Intersection Observer Web API. */
module IntersectionObserver {
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
    treshold : Number,
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
        treshold: #{treshold}
      });
    })()
    `
  }

  /* Observes the given element. */
  fun observe (
    element : Dom.Element,
    observer : IntersectionObserver
  ) : IntersectionObserver {
    `#{observer}.observe(#{element}) || #{observer}`
  }

  /* Unobserves the given element. */
  fun unobserve (
    element : Dom.Element,
    observer : IntersectionObserver
  ) : IntersectionObserver {
    `#{observer}.unobserve(#{element}) || #{observer}`
  }
}
