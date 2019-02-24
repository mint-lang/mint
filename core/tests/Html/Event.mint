suite "Html.Event.stopPropagation" {
  test "it stops propagation" {
    Html.Event.stopPropagation(`{ stopPropagation: () => "A"}`) == `"A"`
  }
}

suite "Html.Event.preventDefault" {
  test "it prevents default" {
    Html.Event.preventDefault(`{ preventDefault: () => "A"}`) == `"A"`
  }
}

suite "Html.Event.isPropagationStopped" {
  test "it prevents default" {
    Html.Event.isPropagationStopped(
      `{ isPropagationStopped: () => true}`) == true
  }
}
