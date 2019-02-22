/* Functions for getting, creating and reading files in different formats. */
module File {
  /*
  Creates a new file from the contents, name and mime-type.

    File.fromString("Some contents...", "test.txt", "text/plain")
  */
  fun fromString (contents : String, name : String, type : String) : File {
    `new File([contents], name, { type: type })`
  }

  /*
  Returns the name of the file.

    (File.fromString("Some contents...", "test.txt", "text/plain")
    |> File.name()) == "test.txt"
  */
  fun name (file : File) : String {
    `file.name`
  }

  /*
  Returns the size of the file in bytes.

    (File.fromString("Some contents...", "test.txt", "text/plain")
    |> File.size()) == 16
  */
  fun size (file : File) : Number {
    `file.size`
  }

  /*
  Returns the size of the file in bytes.

    (File.fromString("Some contents...", "test.txt", "text/plain")
    |> File.mimeType()) == "text/plain"
  */
  fun mimeType (file : File) : String {
    `file.type`
  }

  /*
  Opens the browsers file dialog for selecting multiple files using a promise.

  The mime type can be restricted to the given one.

  It might not esolve if the user cancels the dialog.

    do {
      files =
        File.selectMultiple("application/json")

      Debug.log(files)
    }
  */
  fun selectMultiple (accept : String) : Promise(Never, Array(File)) {
    `
    (() => {
      let input = document.createElement('input')

      input.style.position = 'absolute'
      input.style.height = '1px'
      input.style.width = '1px'
      input.style.left = '-1px'
      input.style.top = '-1px'

      input.multiple = true
      input.accept = accept
      input.type = 'file'

      document.body.appendChild(input)

      return new Promise((resolve, reject) => {
        input.addEventListener('change', () => {
          resolve(Array.from(input.files))
        })
        input.click()
        document.body.removeChild(input)
      })
    })()
    `
  }

  /*
  Opens the browsers file dialog for selecting a single file using a promise.

  The mime type can be restricted to the given one.

  It might not esolve if the user cancels the dialog.

    do {
      file =
        File.select("application/json")

      Debug.log(file)
    }
  */
  fun select (accept : String) : Promise(Never, File) {
    `
    (() => {
      let input = document.createElement('input')

      input.style.position = 'absolute'
      input.style.height = '1px'
      input.style.width = '1px'
      input.style.left = '-1px'
      input.style.top = '-1px'

      input.accept = accept
      input.type = 'file'

      document.body.appendChild(input)

      return new Promise((resolve, reject) => {
        input.addEventListener('change', () => {
          resolve(input.files[0])
        })
        input.click()
        document.body.removeChild(input)
      })
    })()
    `
  }

  /*
  Reads the contents of the given file as a Data URL.

    do {
      file =
        File.create("Some content...", "test.txt", "text/plain")

      url =
        File.readAsDataURL(file)

      url == "data:text/plain;...."
    }
  */
  fun readAsDataURL (file : File) : Promise(Never, String) {
    `
    (() => {
      let reader = new FileReader();
      return new Promise((resolve, reject) => {
        reader.addEventListener('load', (event) => {
          resolve(reader.result)
        })
        reader.readAsDataURL(file)
      })
    })()
    `
  }

  /*
  Reads the contents of the given file as a Data URL.

    do {
      file =
        File.create("Some content...", "test.txt", "text/plain")

      url =
        File.readAsString(file)

      url == "Some content..."
    }
  */
  fun readAsString (file : File) : Promise(Never, String) {
    `
    (() => {
      let reader = new FileReader();
      return new Promise((resolve, reject) => {
        reader.addEventListener('load', (event) => {
          resolve(reader.result)
        })
        reader.readAsText(file)
      })
    })()
    `
  }
}
