suite "Html.Portals.Body" {
  test "renders single children into the body" {
    with Test.Html {
      with Test.Context {
        <Html.Portals.Body>
          <portal-body/>
        </Html.Portals.Body>
        |> start()
        |> then(
          (subject : Dom.Element) : Promise(a, Bool) {
            Dom.getElementBySelector("body > portal-body")
            |> Maybe.map((element : Dom.Element) : Bool { true })
            |> Maybe.withDefault(false)
            |> Promise.resolve()
          })
        |> assertEqual(true)
      }
    }
  }

  test "renders multiple children into the body" {
    with Test.Html {
      with Test.Context {
        <Html.Portals.Body>
          <portal-body/>
          <portal-body2/>
        </Html.Portals.Body>
        |> start()
        |> then(
          (subject : Dom.Element) : Promise(a, Bool) {
            Dom.getElementBySelector("body > portal-body2")
            |> Maybe.map((element : Dom.Element) : Bool { true })
            |> Maybe.withDefault(false)
            |> Promise.resolve()
          })
        |> assertEqual(true)
      }
    }
  }
}
