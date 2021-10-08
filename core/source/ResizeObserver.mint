record ResizeObserver.Entry {
  dimensions : Dom.Dimensions,
  target : Dom.Element
}

/* This module provides a wrapper for the Resize Observer Web API. */
module ResizeObserver {
  /*
  Creates a new resize observer.

    observer =
      ResizeObserver.new((entries : ResizeObserver.Entry) {
        for (entry of entries) {
          Debug.log(entry)
        }
      })
  */
  fun new (
    callback : Function(Array(ResizeObserver.Entry), a)
  ) : ResizeObserver {
    `
    new ResizeObserver((entries) => {
      const values = entries.map((item) => {
        return #{
          {
            dimensions =
              decode (`item.contentRect`) as Dom.Dimensions
              |> Result.withDefault(Dom.Dimensions.empty())

            {
              dimensions = dimensions,
              target = `item.target`
            }
          }
        }
      })

      #{callback(`values`)}
    })
    `
  }

  /* Observes the given element. */
  fun observe (element : Dom.Element, observer : ResizeObserver) : ResizeObserver {
    `#{observer}.observe(#{element}) || #{observer}`
  }

  /* Unobserves the given element. */
  fun unobserve (element : Dom.Element, observer : ResizeObserver) : ResizeObserver {
    `#{observer}.unobserve(#{element}) || #{observer}`
  }
}
