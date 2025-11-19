/* A data structure for the resize observers entry. */
type ResizeObserver.Entry {
  dimensions : Dom.Dimensions,
  target : Dom.Element
}

/*
This module provides functions for working with the [Resize Observer Web API].

[Resize Observer Web API]: https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver
*/
module ResizeObserver {
  /*
  Creates a new resize observer.

    let observer =
      ResizeObserver.new((entries : ResizeObserver.Entry) {
        for (entry of entries) {
          Debug.log(entry)
        }
      })
  */
  fun new (callback : Function(Array(ResizeObserver.Entry), a)) : ResizeObserver {
    `
    new ResizeObserver((entries) => {
      const values = entries.map((item) => {
        return #{
          {
            let dimensions =
              decode (`item.contentRect`) as Dom.Dimensions
              |> Result.withDefault(Dom.Dimensions.empty())

            {
              dimensions: dimensions,
              target: `item.target`
            }
          }
        }
      })

      #{callback(`values`)}
    })
    `
  }

  /*
  Observes the element.

    if let Just(element) = Dom.getElementBySelector("div") {
      ResizeObserver.observe(observer, element, true, true)
    }
  */
  fun observe (
    observer : ResizeObserver,
    element : Dom.Element
  ) : ResizeObserver {
    `#{observer}.observe(#{element}) || #{observer}`
  }

  /*
  Unobserves the element.

    if let Just(element) = Dom.getElementBySelector("div") {
      ResizeObserver.unobserve(observer, element)
    }
  */
  fun unobserve (
    observer : ResizeObserver,
    element : Dom.Element
  ) : ResizeObserver {
    `#{observer}.unobserve(#{element}) || #{observer}`
  }
}
