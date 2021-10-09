suite "Timer.timeout" {
  test "resolves after a time" {
    Test.Context.of("TEST")
    |> Test.Context.timeout(1)
    |> Test.Context.then(
      (subject : String) : Promise(String) {
        subject
        |> String.toLowerCase()
        |> Promise.resolve()
      })
    |> Test.Context.then(
      (subject : String) : Promise(Bool) {
        subject == "test"
        |> Promise.resolve()
      })
  }
}

suite "Timer.nextFrame" {
  test "resolves after the next frame" {
    Test.Context.of("TEST")
    |> Test.Context.then(
      (subject : String) : Promise(String) { Timer.nextFrame(subject) })
    |> Test.Context.then(
      (subject : String) : Promise(String) {
        subject
        |> String.toLowerCase()
        |> Promise.resolve()
      })
    |> Test.Context.then(
      (subject : String) : Promise(Bool) {
        subject == "test"
        |> Promise.resolve()
      })
  }
}
