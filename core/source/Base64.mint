module Base64 {
  /* Tries to decode the given Base64 string. */
  fun decode (value : String) : Result(String, String) {
    `
    (() => {
      try {
        return #{Result.Ok(`atob(#{value})`)};
      } catch (error) {
        return #{Result.Err(`error.toString()`)};
      }
    })()
    `
  }

  /* Encodes the given value as Base64. */
  fun encode (value : String) : String {
    `btoa(#{value})`
  }
}
