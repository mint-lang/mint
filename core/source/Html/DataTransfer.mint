/*
A module containing functions to work with the `DataTransfer`[1] JavaScript
object.

[1] https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
*/
module Html.DataTransfer {
  /* Removes the attached data. */
  fun clearData (data : Html.DataTransfer) : Html.DataTransfer {
    `#{data}.clearData() || #{data}`
  }

  /* Returns string data for the given format or an empty string if there is no data. */
  fun getData (data : Html.DataTransfer, format : String) : String {
    `#{data}.getData(#{format})`
  }

  /* Gets the type of drag-and-drop operation which is currently selected. */
  fun getDropEffect (data : Html.DataTransfer) : String {
    `#{data}.dropEffect`
  }

  /* Returns the type of operation that is possible. */
  fun getEffectAllowed (data : Html.DataTransfer) : String {
    `#{data}.effectAllowed`
  }

  /* Returns the files which is contained in the data transfer. */
  fun getFiles (data : Html.DataTransfer) : Array(File) {
    `#{data}.files || []`
  }

  /* Returns the types of the data which is available. */
  fun getTypes (data : Html.DataTransfer) : Array(String) {
    `#{data}.types || []`
  }

  /* Sets the data fro the data transfer. */
  fun setData (
    data : Html.DataTransfer,
    format : String,
    value : String
  ) : Html.DataTransfer {
    `#{data}.setData(#{format}, #{value}) || #{data}`
  }

  /* Sets the element as the drag image of the data transfer. */
  fun setDragImage (
    data : Html.DataTransfer,
    element : Dom.Element,
    offsetX : Number,
    offsetY : Number
  ) : Html.DataTransfer {
    `#{data}.setDragImage(#{element}, #{offsetX}, #{offsetY}) || #{data}`
  }

  /* Sets the operation to a new type. The value must be `none`, `copy`, `link` or `move`. */
  fun setDropEffect (data : Html.DataTransfer, value : String) : Html.DataTransfer {
    `(#{data}.dropEffect = #{value}) && #{data}`
  }

  /* Sets of the type of operation that are possible. */
  fun setEffectAllowed (data : Html.DataTransfer, value : String) : Html.DataTransfer {
    `(#{data}.effectAllowed = #{value}) && #{data}`
  }
}
