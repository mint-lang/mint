/*
This module provides functions for the encoding and decoding of binary data
using a [Base64] representation.

[Base64]: https://en.wikipedia.org/wiki/Base64
*/
module Base64 {
  /*
  Returns the Base64-decoded version of `value` as a `Result`.

    Base64.decode("dGVzdA==") == Result.Ok("test")
  */
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

  /*
  Returns the Base64-encoded version of `value`.

    Base64.encode("test") == "dGVzdA=="
  */
  fun encode (value : String) : String {
    `btoa(#{value})`
  }
}
