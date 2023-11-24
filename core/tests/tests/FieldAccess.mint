suite "Field Access" {
  test "it returns the value" {
    let options =
      {
        caseInsensitive: true,
        multiline: true,
        sticky: false,
        unicode: true,
        global: true
      }

    .sticky(Regexp.Options)(options) == false
  }
}
