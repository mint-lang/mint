/* Functions for encoding values to an `Object`. */
module Object.Encode {
  /* Encodes a `String` */
  string (input : String) : Object {
    `#{input}`
  }

  /* Encodes a `Bool` */
  boolean (input : Bool) : Object {
    `#{input}`
  }

  /* Encodes a `Number` */
  number (input : Number) : Object {
    `#{input}`
  }

  /* Encodes a `Time` */
  time (input : Time) : Object {
    `#{input}.toISOString()`
  }

  /* Encodes an `Array` of objects. */
  array (input : Array(Object)) : Object {
    `#{input}`
  }

  /* Encodes a field of an object. */
  field (name : String, value : Object) : Object.Field {
    `{ name: #{name}, value: #{value} }`
  }

  /* Encodes an array of fields as an object. */
  object (fields : Array(Object.Field)) : Object {
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
}
