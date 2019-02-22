/* Functions for encoding values to an `Object`. */
module Object.Encode {
  /* Encodes a `String` */
  fun string (input : String) : Object {
    `input`
  }

  /* Encodes a `Bool` */
  fun boolean (input : Bool) : Object {
    `input`
  }

  /* Encodes a `Number` */
  fun number (input : Number) : Object {
    `input`
  }

  /* Encodes a `Time` */
  fun time (input : Time) : Object {
    `input.toISOString()`
  }

  /* Encodes an `Array` of objects. */
  fun array (input : Array(Object)) : Object {
    `input`
  }

  /* Encodes a field of an object. */
  fun field (name : String, value : Object) : Object.Field {
    `{ name: name, value: value }`
  }

  /* Encodes an array of fields as an object. */
  fun object (fields : Array(Object.Field)) : Object {
    `
    (() => {
      let result = {}

      for (let item of fields) {
        result[item.name] = item.value
      }

      return result
    })()
    `
  }
}
