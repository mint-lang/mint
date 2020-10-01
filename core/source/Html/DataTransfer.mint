module Html.DataTransfer {
  fun getEffectAllowed (data : Html.DataTransfer) : String {
    `#{data}.effectAllowed`
  }

  fun setEffectAllowed (value : String, data : Html.DataTransfer) : Html.DataTransfer {
    `(#{data}.effectAllowed = #{value}) && #{data}`
  }

  fun getDropEffect (data : Html.DataTransfer) : String {
    `#{data}.dropEffect`
  }

  fun setDropEffect (value : String, data : Html.DataTransfer) : Html.DataTransfer {
    `(#{data}.dropEffect = #{value}) && #{data}`
  }

  fun getTypes (data : Html.DataTransfer) : Array(String) {
    `#{data}.types || []`
  }

  fun getFiles (data : Html.DataTransfer) : Array(File) {
    `#{data}.files || []`
  }

  fun getData(format : String, data : Html.DataTransfer) : String {
    `#{data}.getData(#{format})`
  }

  fun setData(format : String, value : String, data : Html.DataTransfer) : Html.DataTransfer {
    `#{data}.setData(#{format}, #{value}) || #{data}`
  }

  fun clearData(data : Html.DataTransfer) : Html.DataTransfer {
    `#{data}.clearData() || #{data}`
  }

  fun setDragImage(element : Dom.Element, offsetX : Number, offsetY: Number, data : Html.DataTransfer) : Html.DataTransfer {
    `#{data}.setDragImage(#{element}, #{offsetX}, #{offsetY}) || #{data}`
  }
}
