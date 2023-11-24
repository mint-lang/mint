locale en {
  key: "Hello World!"
}

locale hu {
  key: "Szia Világ!"
}

component Test.Locale {
  fun render : Html {
    <div onClick={(event : Html.Event) { Locale.set("hu") }}>
      :key
    </div>
  }
}

suite "Locale" {
  test "Translates" {
    <Test.Locale/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div", "Hello World!")
    |> Test.Html.triggerClick("div")
    |> Test.Html.assertTextOf("div", "Szia Világ!")
  }
}
