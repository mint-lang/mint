suite "Defer" {
  const DEFERRED = defer "Hello World!"

  test "it loads deferred content" {
    let greeting =
      await DEFERRED

    greeting == "Hello World!"
  }
}
