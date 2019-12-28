module FileSize {
  /*
  Formats a number as a file size.

    FileSize.format(0) == "0 B"
    FileSize.format(1024) == "1 kB"
    FileSize.format(1048576) == "1 MB"
    FileSize.format(1073741824) == "1 GB"
  */
  fun format (size : Number) : String {
    `
    (() => {
      if (#{size} == 0){
        return "0 B"
      } else {
        const index = Math.floor(Math.log(#{size}) / Math.log(1024));
        const affix = ['B', 'kB', 'MB', 'GB', 'TB'][index]
        return (#{size} / Math.pow(1024, index)).toFixed(2) * 1 + ' ' + affix;
      }
    })()
    `
  }
}
