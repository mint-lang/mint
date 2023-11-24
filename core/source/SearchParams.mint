/* Module for manipulating search parameters. */
module SearchParams {
  /*
  Appends a specified key/value pair as a new search parameter.

    SearchParams.empty()
    |> SearchParams.append("key", "value")
  */
  fun append (params : SearchParams, key : String, value : String) : SearchParams {
    `
    (() => {
      let newParams = new URLSearchParams(#{params}.toString())
      newParams.append(#{key}, #{value})
      return newParams
    })()
    `
  }

  /*
  Returns a `Bool` indicating if such a search parameter exists.

    (SearchParams.fromString("key=value")
     |> SearchParams.contains("key")) == true
  */
  fun contains (params : SearchParams, key : String) : Bool {
    `#{params}.has(#{key})`
  }

  /*
  Deletes the given search parameter, and its associated value, from the
  list of all search parameters.

    SearchParams.fromString("key=value")
    |> SearchParams.delete("key")
  */
  fun delete (params : SearchParams, key : String) : SearchParams {
    `
    (() => {
      let newParams = new URLSearchParams(#{params}.toString())
      newParams.delete(#{key})
      return newParams
    })()
    `
  }

  /*
  Returns an empty search parameters object.

    SearchParams.empty()
  */
  fun empty : SearchParams {
    `new URLSearchParams()`
  }

  /*
  Parses a string into a search parameters object.

    SearchParams.fromString("key=value")
  */
  fun fromString (value : String) : SearchParams {
    `new URLSearchParams(#{value})`
  }

  /*
  Returns the first value associated to the given search parameter.

    (SearchParams.fromString("key=value")
     |> SearchParams.get("key")) == "value"
  */
  fun get (params : SearchParams, key : String) : Maybe(String) {
    `
    (() => {
      let value = #{params}.get(#{key})

      if (value === null) {
        return #{Maybe.Nothing}
      } else {
        return #{Maybe.Just(`value`)}
      }
    })()
    `
  }

  /*
  Sets the value associated to a given search parameter to the given value.
  If there were several values, delete the others.

    SearchParams.empty()
    |> SearchParams.set("key", "value")
  */
  fun set (params : SearchParams, key : String, value : String) : SearchParams {
    `
    (() => {
      let newParams = new URLSearchParams(#{params}.toString())
      newParams.set(#{key}, #{value})
      return newParams
    })()
    `
  }

  /*
  Returns a string containing a query string suitable for use in a URL.

    (SearchParams.empty()
     |> SearchParams.set("key", "value")
     |> SearchParams.toString()) == "key=value"
  */
  fun toString (params : SearchParams) : String {
    `#{params}.toString()`
  }
}
