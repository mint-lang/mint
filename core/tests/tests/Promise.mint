component Test.Promise {
  state result : String = ""

  reject : Promise(Never, Void) {
    sequence {
      rejected =
        Promise.reject("rejected")

      Promise.never()
    } catch String => error {
      next { result = error }
    }
  }

  resolve : Promise(Never, Void) {
    sequence {
      newResult =
        Promise.resolve("resolved")

      next { result = newResult }
    } catch {
      next {  }
    }
  }

  render : Html {
    <div>
      <result>
        <{ result }>
      </result>

      <resolve onClick={(event : Html.Event) : Promise(Never, Void) { resolve() }}/>
      <reject onClick={(event : Html.Event) : Promise(Never, Void) { reject() }}/>
    </div>
  }
}

suite "Promise.resolve" {
  test "resolves a promise" {
    with Test.Html {
      <Test.Promise/>
      |> start()
      |> assertTextOf("result", "")
      |> triggerClick("resolve")
      |> assertTextOf("result", "resolved")
    }
  }
}

suite "Promise.reject" {
  test "rejects a promise" {
    with Test.Html {
      <Test.Promise/>
      |> start()
      |> assertTextOf("result", "")
      |> triggerClick("reject")
      |> assertTextOf("result", "rejected")
    }
  }
}
