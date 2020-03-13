/* Module for manipulating search parameters. */
module SearchParams {
  /* Returns an empty search parameters object. */
  empty : SearchParams {
    `new URLSearchParams()`
  }

  /* Parses a string into a search parameters object. */
  fromString (value : String) : SearchParams {
    `new URLSearchParams(#{value})`
  }

  /* Returns the first value associated to the given search parameter. */
  get (key : String, params : SearchParams) : Maybe(String) {
    `
    (() => {
      let value = #{params}.get(#{key})

      if (value === null) {
        return #{Maybe::Nothing}
      } else {
        return #{Maybe::Just(`value`)}
      }
    })()
    `
  }

  /* Returns a `Bool` indicating if such a search parameter exists. */
  has (key : String, params : SearchParams) : Bool {
    `#{params}.has(#{key})`
  }

  /*
  Deletes the given search parameter, and its associated value, from the
  list of all search parameters.
  */
  delete (key : String, params : SearchParams) : SearchParams {
    `
    (() => {
      let newParams = new URLSearchParams(#{params}.toString())
      newParams.delete(#{key})
      return newParams
    })()
    `
  }

  /*
  Sets the value associated to a given search parameter to the given value.
  If there were several values, delete the others.
  */
  set (key : String, value : String, params : SearchParams) : SearchParams {
    `
    (() => {
      let newParams = new URLSearchParams(#{params}.toString())
      newParams.set(#{key}, #{value})
      return newParams
    })()
    `
  }

  /* Appends a specified key/value pair as a new search parameter. */
  append (key : String, value : String, params : SearchParams) : SearchParams {
    `
    (() => {
      let newParams = new URLSearchParams(#{params}.toString())
      newParams.append(#{key}, #{value})
      return newParams
    })()
    `
  }

  /* Returns a string containing a query string suitable for use in a URL. */
  toString (params : SearchParams) : String {
    `#{params}.toString()`
  }
}
