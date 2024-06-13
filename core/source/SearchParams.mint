/*
This module provides functions for working with the [URLSearchParams Web
API](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams).
*/
module SearchParams {
  /*
  Appends a specified key-value pair.

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
  Deletes the given search parameter, and its associated value(s), from the
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
  Returns an empty `SearchParams` object.

    SearchParams.empty()
  */
  fun empty : SearchParams {
    `new URLSearchParams()`
  }

  /*
  Parses a string into a `SearchParams` object.

    SearchParams.fromString("key=value")
  */
  fun fromString (value : String) : SearchParams {
    `new URLSearchParams(#{value})`
  }

  /*
  Returns the first value associated of the key.

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
  Sets the value associated to the key. If there were several values, deletes
  the others.

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
