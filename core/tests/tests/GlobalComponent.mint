global component GlobalTest {
  fun render : Html {
    <div class="global-component"/>
  }
}

suite "Global Component" {
  test "It renders on the page" {
    Dom.getElementBySelector(".global-component") != Maybe.Nothing
  }
}
