component Test.Promise {
  state result : String = ""

  fun reject : Promise(Never, Void) {
    sequence {
      rejected =
        Promise.reject("rejected")

      Promise.never()
    } catch String => error {
      next { result = error }
    }
  }

  fun resolve : Promise(Never, Void) {
    sequence {
      newResult =
        Promise.resolve("resolved")

      next { result = newResult }
    } catch {
      next { }
    }
  }

  fun render : Html {
    <div>
      <result>
        <{ result }>
      </result>

      <resolve onClick={(event : Html.Event) : Promise(Never, Void) { resolve() }}/>
      <reject onClick={(event : Html.Event) : Promise(Never, Void) { reject() }}/>
    </div>
  }
}

component Test.Promise2 {
  state resolve : Function(String, Void) = (error : String) { void }
  state reject : Function(String, Void) = (error : String) { void }
  state result : String = ""

  fun componentDidMount : Promise(Never, Void) {
    {resolve, reject, promise} =
      Promise.create()

    sequence {
      next
        {
          resolve = resolve,
          reject = reject
        }

      newResult =
        promise

      next { result = newResult }
    } catch {
      next { result = "rejected" }
    }
  }

  fun render : Html {
    <div>
      <result>
        <{ result }>
      </result>

      <resolve onClick={(event : Html.Event) { resolve("resolved") }}/>
      <reject onClick={(event : Html.Event) { reject("rejected") }}/>
    </div>
  }
}

suite "Promise.create" {
  test "resolve resolves a promise" {
    <Test.Promise2/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("result", "")
    |> Test.Html.triggerClick("resolve")
    |> Test.Html.assertTextOf("result", "resolved")
  }

  test "reject rejects a promise" {
    <Test.Promise2/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("result", "")
    |> Test.Html.triggerClick("reject")
    |> Test.Html.assertTextOf("result", "rejected")
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

suite "Promise.reject" {
  test "rejects a promise" {
    <Test.Promise/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("result", "")
    |> Test.Html.triggerClick("reject")
    |> Test.Html.assertTextOf("result", "rejected")
  }
}
