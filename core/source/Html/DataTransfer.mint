/*
This module provides functions for working with the [DataTransfer Web API].
This is used for drag and drop functionality. `Html.Event` contains the fields
`dataTransfer` and `clipboardData` which are `Html.DataTransfer` objects.

[DataTransfer Web API]: https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
*/
module Html.DataTransfer {
  /*
  Removes the attached data.

    Html.DataTransfer.clearData(data)
  */
  fun clearData (data : Html.DataTransfer) : Html.DataTransfer {
    `#{data}.clearData() || #{data}`
  }

  /*
  Returns string data for the format or an empty string if there is no data.

    let string =
      Html.DataTransfer.getData(event.dataTransfer, "text/plain")
  */
  fun getData (data : Html.DataTransfer, format : String) : String {
    `#{data}.getData(#{format})`
  }

  /*
  Returns the type of drag-and-drop operation which is currently selected.

    let dropEffect =
      Html.DataTransfer.getDropEffect(event.dataTransfer)
  */
  fun getDropEffect (data : Html.DataTransfer) : String {
    `#{data}.dropEffect`
  }

  /*
  Returns the type of operation that is possible.

    let effectAllowed =
      Html.DataTransfer.getEffectAllowed(event.dataTransfer)
  */
  fun getEffectAllowed (data : Html.DataTransfer) : String {
    `#{data}.effectAllowed`
  }

  /*
  Returns the files which is contained in the data transfer.

    let files =
      Html.DataTransfer.getFiles(event.dataTransfer)
  */
  fun getFiles (data : Html.DataTransfer) : Array(File) {
    `#{data}.files || []`
  }

  /*
  Returns the types of the data which is available.

    let types =
      Html.DataTransfer.getTypes(event.dataTransfer)
  */
  fun getTypes (data : Html.DataTransfer) : Array(String) {
    `#{data}.types || []`
  }

  /*
  Sets the value for the format in the data transfer.

    Html.DataTransfer.setData(event.dataTransfer, "text/plain", "Hello!")
  */
  fun setData (
    data : Html.DataTransfer,
    format : String,
    value : String
  ) : Html.DataTransfer {
    `#{data}.setData(#{format}, #{value}) || #{data}`
  }

  /*
  Sets the element as the drag image of the data transfer.

    if let Just(element) = Dom.getElementBySelector("div") {
      Html.DataTransfer.setDragImage(event.dataTransfer, element, 0, 0)
    }
  */
  fun setDragImage (
    data : Html.DataTransfer,
    element : Dom.Element,
    offsetX : Number,
    offsetY : Number
  ) : Html.DataTransfer {
    `#{data}.setDragImage(#{element}, #{offsetX}, #{offsetY}) || #{data}`
  }

  /*
  Sets the operation to a new type. The value must be `"none"`, `"copy"`,
  `"link"` or `"move"`.

    Html.DataTransfer.setDropEffect(event.dataTransfer, "copy")
  */
  fun setDropEffect (data : Html.DataTransfer, value : String) : Html.DataTransfer {
    `(#{data}.dropEffect = #{value}) && #{data}`
  }

  /*
  Sets of the type of operation that are possible.

    Html.DataTransfer.setEffectAllowed(event.dataTransfer, "copy")
  */
  fun setEffectAllowed (data : Html.DataTransfer, value : String) : Html.DataTransfer {
    `(#{data}.effectAllowed = #{value}) && #{data}`
  }
}
