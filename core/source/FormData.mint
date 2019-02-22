/*
Module to work with the [FormData Web API](https://developer.mozilla.org/en-US/docs/Web/API/FormData).

FormData is generally used when sending messages via HTTP requests.
*/
module FormData {
  /*
  Returns an empty FormData object.

    FormData.empty()
    |> FormData.addString("key", "value")
  */
  fun empty : FormData {
    `new FormData`
  }

  /*
  Returns the keys of a FromData object.

    FormData.empty()
    |> FormData.addString("key", "value")
    |> FormData.keys() == ["key"]
  */
  fun keys (formData : FormData) : Array(String) {
    `Array.from(formData.keys())`
  }

  /*
  Returns a new FormData object copying all values from the given one and
  adding the given string with the given key.

    FormData.empty()
    |> FormData.addString("key", "value")
  */
  fun addString (key : String, value : String, formData : FormData) : FormData {
    `
     (() => {
      var newFormData = new FormData();

      // Create new FormData object
      for(let pair of formData.entries()) {
        newFormData.append(pair[0], pair[1])
      }

      newFormData.append(key, value)

      return newFormData
    })()
    `
  }

  /*
  Returns a new FormData object copying all values from the given one and
  adding the given file with the given key.

    FormData.empty()
    |> FormData.addFile(
      "key", File.fromString("Contents", "text.txt", "text/plain"))
  */
  fun addFile (key : String, value : File, formData : FormData) : FormData {
    `
     (() => {
      var newFormData = new FormData();

      // Create new FormData object
      for(let pair of formData.entries()) {
        newFormData.append(pair[0], pair[1])
      }

      newFormData.append(key, value)

      return newFormData
    })()
    `
  }
}
