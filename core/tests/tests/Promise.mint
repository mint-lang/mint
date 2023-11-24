component Test.Promise {
  state result : String = ""

  fun resolve : Promise(Void) {
    let newResult =
      await Promise.resolve("resolved")

    await next { result: newResult }
  }

  fun render : Html {
    <div>
      <result>
        result
      </result>

      <resolve onClick={(event : Html.Event) : Promise(Void) { resolve() }}/>
    </div>
  }
}

component Test.Promise2 {
  state resolve : Function(String, Void) = (result : String) { void }
  state result : String = ""

  fun componentDidMount : Promise(Void) {
    let {resolve, promise} =
      Promise.create()

    await next { resolve: resolve }

    let newResult =
      await promise

    await next { result: newResult }
  }

  fun render : Html {
    <div>
      <result>
        result
      </result>

      <resolve onClick={(event : Html.Event) { resolve("resolved") }}/>
    </div>
  }
}

suite "Promise.create" {
  test "resolves a promise" {
    <Test.Promise2/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("result", "")
    |> Test.Html.triggerClick("resolve")
    |> Test.Html.assertTextOf("result", "resolved")
  }
}

suite "Promise.resolve" {
  test "resolves a promise" {
    <Test.Promise/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("result", "")
    |> Test.Html.triggerClick("resolve")
    |> Test.Html.assertTextOf("result", "resolved")
  }
}
