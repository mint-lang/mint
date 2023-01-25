/*
Module to work with the [FormData Web API](https://developer.mozilla.org/en-US/docs/Web/API/FormData).

FormData is generally used when sending messages via HTTP requests.
*/
module FormData {
  /*
  Returns a new FormData object copying all values from the given one and
  adding the given file with the given key.

    FormData.empty()
    |> FormData.addFile(
      "key", File.fromString("Contents", "text.txt", "text/plain"))
  */
  fun addFile (formData : FormData, key : String, value : File) : FormData {
    `
     (() => {
      var newFormData = new FormData();

      for(let pair of #{formData}.entries()) {
        newFormData.append(pair[0], pair[1])
      }

      newFormData.append(#{key}, #{value})

      return newFormData
    })()
    `
  }

  /*
  Returns a new FormData object copying all values from the given one and
  adding the given string with the given key.

    FormData.empty()
    |> FormData.addString("key", "value")
  */
  fun addString (formData : FormData, key : String, value : String) : FormData {
    `
     (() => {
      var newFormData = new FormData();

      for(let pair of #{formData}.entries()) {
        newFormData.append(pair[0], pair[1])
      }

      newFormData.append(#{key}, #{value})

      return newFormData
    })()
    `
  }

  /*
  Returns an empty FormData object.

    FormData.empty()
    |> FormData.addString("key", "value")
  */
  fun empty : FormData {
    `new FormData`
  }

  /*
  Returns the keys of a FormData object.

    FormData.empty()
    |> FormData.addString("key", "value")
    |> FormData.keys() == ["key"]
  */
  fun keys (formData : FormData) : Array(String) {
    `Array.from(#{formData}.keys())`
  }
}
