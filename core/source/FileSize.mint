module FileSize {
  /*
  Formats a number as a file size.

    FileSize.format(0) == "0 B"
    FileSize.format(1024) == "1 kB"
    FileSize.format(1048576) == "1 MB"
    FileSize.format(1073741824) == "1 GB"
  */
  fun format (size : Number) : String {
    if size == 0 {
      "0 B"
    } else {
      let index =
        Math.floor(Math.log(size) / Math.log(1024))

      let affix =
        ["B", "kB", "MB", "GB", "TB"][index] or ""

      // We calculate the number, then convert it to String
      // with 2 decimals and then parse it again.
      let number =
        (size / Math.pow(1024, index)
        |> Number.toFixed(2)
        |> Number.fromString()) or 0

      "#{number} #{affix}"
    }
  }
}
