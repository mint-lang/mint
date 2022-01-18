/*
Module to work with the [ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer).

ArrayBuffer is used to encode binary data.
*/
module ArrayBuffer {
  /*
  Converts the given string to an ArrayBuffer.

    ("Hello"
    |> ArrayBuffer.toArrayBuffer()
    |> ArrayBuffer.toString()) == "Hello"
  */
  fun toArrayBuffer (string : String) : ArrayBuffer {
    `new TextEncoder().encode(#{string})`
  }

  /*
  Converts an ArrayBuffer to an UTF-8 string.

    ("Hello"
    |> ArrayBuffer.toArrayBuffer()
    |> ArrayBuffer.toString()) == "Hello"
  */
  fun toString (buffer : ArrayBuffer) : String {
    `new TextDecoder().decode(#{buffer})`
  }
}
