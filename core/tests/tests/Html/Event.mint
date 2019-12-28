suite "Html.Event.stopPropagation" {
  test "it stops propagation" {
    Html.Event.stopPropagation(
      `{ event: { stopPropagation: () => "A" }}`) == `"A"`
  }
}

suite "Html.Event.preventDefault" {
  test "it prevents default" {
    Html.Event.preventDefault(
      `{ event: { preventDefault: () => "A" }}`) == `"A"`
  }
}

suite "Html.Event.isPropagationStopped" {
  test "it prevents default" {
    Html.Event.isPropagationStopped(
      `{ event: { isPropagationStopped: () => true } }`) == true
  }
}
