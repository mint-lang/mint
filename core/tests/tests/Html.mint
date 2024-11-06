suite "Html.empty" {
  test "true" {
    Html.empty() == <></>
  }
}

suite "Html.isEmpty" {
  test "true" {
    Html.isEmpty(<></>) == true
  }

  test "true" {
    Html.isEmpty(<div/>) == false
  }
}

suite "Html.isNotEmpty" {
  test "true" {
    Html.isNotEmpty(<></>) == false
  }

  test "true" {
    Html.isNotEmpty(<div/>) == true
  }
}
