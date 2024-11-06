/*
This module provides functions for working with the [FormData Web API]. It is
generally used when sending messages via HTTP requests.

[FormData Web API]: https://developer.mozilla.org/en-US/docs/Web/API/FormData
*/
module FormData {
  /*
  Returns a new `FormData` object containing all the values from the original,
  with the file added as a key.

    let file =
      File.fromString("Contents", "text.txt", "text/plain")

    FormData.empty()
    |> FormData.addFile("key", file)
  */
  fun addFile (original : FormData, key : String, file : File) : FormData {
    `
     (() => {
      var newFormData = new FormData();

      for(let pair of #{original}.entries()) {
        newFormData.append(pair[0], pair[1])
      }

      newFormData.append(#{key}, #{file})

      return newFormData
    })()
    `
  }

  /*
  Returns a new `FormData` object containing all the values from the original,
  with the string added as a key.

    FormData.empty()
    |> FormData.addString("key", "value")
  */
  fun addString (original : FormData, key : String, string : String) : FormData {
    `
     (() => {
      var newFormData = new FormData();

      for(let pair of #{original}.entries()) {
        newFormData.append(pair[0], pair[1])
      }

      newFormData.append(#{key}, #{string})

      return newFormData
    })()
    `
  }

  /*
  Returns an empty `FormData` object.

    FormData.empty()
    |> FormData.addString("key", "value")
  */
  fun empty : FormData {
    `new FormData`
  }

  /*
  Returns the keys of a `FormData` object.

    FormData.empty()
    |> FormData.addString("key", "value")
    |> FormData.keys() == ["key"]
  */
  fun keys (formData : FormData) : Array(String) {
    `Array.from(#{formData}.keys())`
  }
}
