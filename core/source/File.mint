/* Functions for getting, creating and reading files in different formats. */
module File {
  /*
  Prompts a dialog for the saving the given file.

    let file =
      await File.select("*")

    File.download(file)
  */
  fun download (file : File) : Void {
    let url =
      Url.createObjectUrlFromFile(file)

    `
    (() => {
      const anchor = document.createElement('a')
      anchor.download = #{file}.name
      anchor.href = #{url}
      anchor.click()
    })()
    `

    Url.revokeObjectUrl(url)
  }

  /*
  Creates a new file from the contents, name and mime-type.

    File.fromString("Some contents...", "test.txt", "text/plain")
  */
  fun fromString (contents : String, name : String, type : String) : File {
    `new File([#{contents}], #{name}, { type: #{type} })`
  }

  /*
  Returns the mime type of the file.

    (File.fromString("Some contents...", "test.txt", "text/plain")
    |> File.mimeType()) == "text/plain"
  */
  fun mimeType (file : File) : String {
    `#{file}.type`
  }

  /*
  Returns the name of the file.

    (File.fromString("Some contents...", "test.txt", "text/plain")
    |> File.name()) == "test.txt"
  */
  fun name (file : File) : String {
    `#{file}.name`
  }

  /*
  Reads the contents of the given file as a String.

    let file =
      File.create("Some content...", "test.txt", "text/plain")

    File.readAsArrayBuffer(file)
  */
  fun readAsArrayBuffer (file : File) : Promise(ArrayBuffer) {
    `
    (() => {
      const reader = new FileReader()

      return new Promise((resolve, reject) => {
        reader.addEventListener('load', (event) => { resolve(reader.result) })
        reader.readAsArrayBuffer(#{file})
      })
    })()
    `
  }

  /*
  Reads the contents of the given file as a Data URL.

    let files =
      await File.select("text/plain")

    let url =
      await File.readAsDataURL(file)

    url == "data:text/plain;...."
  */
  fun readAsDataURL (file : File) : Promise(String) {
    `
    (() => {
      const reader = new FileReader()

      return new Promise((resolve, reject) => {
        reader.addEventListener('load', (event) => { resolve(reader.result) })
        reader.readAsDataURL(#{file})
      })
    })()
    `
  }

  /*
  Reads the contents of the given file as a String.

    let file =
      File.create("Some content...", "test.txt", "text/plain")

    let url =
      await File.readAsString(file)

    url == "Some content..."
  */
  fun readAsString (file : File) : Promise(String) {
    `
    (() => {
      const reader = new FileReader()

      return new Promise((resolve, reject) => {
        reader.addEventListener('load', (event) => { resolve(reader.result) })
        reader.readAsText(#{file})
      })
    })()
    `
  }

  /*
  Opens the browsers file dialog for selecting a single file.

  * The mime type can be restricted to the given one.
  * It might not resolve if the user cancels the dialog.

    let file =
      await File.select("application/json")

    Debug.log(file)
  */
  fun select (accept : String) : Promise(File) {
    `
    (() => {
      const input = document.createElement('input')

      input.style.position = 'absolute'
      input.style.height = '1px'
      input.style.width = '1px'
      input.style.left = '-1px'
      input.style.top = '-1px'

      input.accept = #{accept}
      input.type = 'file'

      document.body.appendChild(input)

      return new Promise((resolve) => {
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
  Opens the browsers file dialog for selecting multiple files.

  * The mime type can be restricted to the given one.
  * It might not resolve if the user cancels the dialog.

    let files =
      await File.selectMultiple("application/json")

    Debug.log(files)
  */
  fun selectMultiple (accept : String) : Promise(Array(File)) {
    `
    (() => {
      const input = document.createElement('input')

      input.style.position = 'absolute'
      input.style.height = '1px'
      input.style.width = '1px'
      input.style.left = '-1px'
      input.style.top = '-1px'

      input.accept = #{accept}
      input.multiple = true
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
  Returns the size of the file in bytes.

    (File.fromString("Some contents...", "test.txt", "text/plain")
    |> File.size()) == 16
  */
  fun size (file : File) : Number {
    `#{file}.size`
  }
}
