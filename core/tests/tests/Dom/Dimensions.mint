suite "Dom.Dimensions.empty" {
  test "returns an empty dimensions object" {
    Dom.Dimensions.empty() == {
      bottom = 0,
      height = 0,
      width = 0,
      right = 0,
      left = 0,
      top = 0,
      x = 0,
      y = 0
    }
  }
}
