/* This module provides functions for encoding values to an `Object`. */
module Object.Encode {
  /*
  Encodes an `Array` of objects.

    Object.Encode.array(["Hello", "World"])
  */
  fun array (input : Array(Object)) : Object {
    `#{input}`
  }

  /*
  Encodes a `Bool`

    Object.Encode.bool(true)
  */
  fun boolean (input : Bool) : Object {
    `#{input}`
  }

  /*
  Encodes a field of an object.

    Object.Encode.field("key", Object.Encode.string("value"))
  */
  fun field (name : String, value : Object) : Object.Field {
    `{ name: #{name}, value: #{value} }`
  }

  /*
  Encodes a `Number`

    Object.Encode.number(10)
  */
  fun number (input : Number) : Object {
    `#{input}`
  }

  /*
  Encodes an array of fields as an object.

    Object.Encode.object([
      Object.Encode.field("key", Object.Encode.string("value")),
      Object.Encode.field("key2", Object.Encode.string("value2"))
    ])
  */
  fun object (fields : Array(Object.Field)) : Object {
    `
    (() => {
      let result = {}

      for (let item of #{fields}) {
        result[item.name] = item.value
      }

      return result
    })()
    `
  }

  /*
  Encodes a `String`.

    Object.Encode.string("Hello")
  */
  fun string (input : String) : Object {
    `#{input}`
  }

  /*
  Encodes a `Time`.

    Object.Encode.time(Time.now())
  */
  fun time (input : Time) : Object {
    `#{input}.toISOString()`
  }
}
