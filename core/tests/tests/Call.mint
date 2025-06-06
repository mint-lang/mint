suite "call" {
  test "with captures" {
    (Maybe.Just("str3")
    |> Maybe.map(Array.push(["str1", "str2"], _))
    |> Maybe.withDefault([])) == ["str1", "str2", "str3"]
  }
}
