component ScrollTest {
  state scrollWidth = 0
  state scrollLeft = 0
  state scrollTop = 0

  use Provider.Scroll {
    scrolls:
      (event : Html.Event) : Promise(Void) {
        update()
      }
  }

  style base {
    height: 3000px;
    width: 3000px;
  }

  fun componentDidMount : Promise(Void) {
    update()
  }

  fun update {
    next
      {
        scrollWidth: Window.scrollWidth(),
        scrollLeft: Window.scrollLeft(),
        scrollTop: Window.scrollTop()
      }
  }

  fun render : Html {
    <div::base>
      <scroll-width>
        Number.toString(scrollWidth)
      </scroll-width>

      "|"

      <scroll-height>
        Number.toString(Window.scrollHeight())
      </scroll-height>

      "|"

      <scroll-left>
        Number.toString(scrollLeft)
      </scroll-left>

      "|"

      <scroll-top>
        Number.toString(scrollTop)
      </scroll-top>
    </div>
  }
}

suite "Window.navigate" {
  test "it navigates to the given url with push state" {
    Window.navigate("/blah")
    String.endsWith(Window.href(), "/blah")
  }
}

suite "Window.title" {
  test "returns the current title" {
    Window.title() == ""
  }
}

suite "Window.setTitle" {
  test "sets the windows title" {
    Window.setTitle("Test")
    Window.title() == "Test"
  }
}

suite "Window.url" {
  test "returns the current url" {
    Window.url().hostname == `window.location.hostname`
  }
}

suite "Window.href" {
  test "returns the current url as string" {
    Window.href() == `window.location.href`
  }
}

suite "Window.width" {
  test "returns the windows width" {
    Window.width() == `window.innerWidth`
  }
}

suite "Window.height" {
  test "returns the windows height" {
    Window.height() == `window.innerHeight`
  }
}

suite "Window.scrollWidth" {
  test "returns the scrollable width" {
    Window.scrollWidth() == `(document.documentElement.scrollWidth || document.body.scrollWidth)`
  }

  test "returns the scrollable width when overflown" {
    <ScrollTest/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("scroll-width", "3008")
  }
}

suite "Window.scrollHeight" {
  test "returns the scrollable height" {
    Window.scrollHeight() == `(document.documentElement.scrollHeight || document.body.scrollHeight)`
  }

  test "returns the scrollable height when overflown" {
    <ScrollTest/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("scroll-height", "3016")
  }
}

suite "Window.scrollLeft" {
  test "returns the left scroll position" {
    Window.scrollLeft() == `window.pageXOffset`
  }

  test "returns the left scroll position when scrolled" {
    <ScrollTest/>
    |> Test.Html.start()
    |> Test.Window.setScrollLeft(100)
    |> Test.Html.assertTextOf("scroll-left", "100")
  }
}

suite "Window.scrollTop" {
  test "returns the left scroll position" {
    Window.scrollTop() == `window.pageYOffset`
  }

  test "returns the left scroll position when scrolled" {
    <ScrollTest/>
    |> Test.Html.start()
    |> Test.Window.setScrollTop(100)
    |> Test.Html.assertTextOf("scroll-top", "100")
  }
}

suite "Window.setScrollLeft" {
  test "sets the left scroll position" {
    <ScrollTest/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("scroll-left", "0")
    |> Test.Window.setScrollLeft(100)
    |> Test.Html.assertTextOf("scroll-left", "100")
  }
}

suite "Window.setScrollTop" {
  test "sets the top scroll position" {
    <ScrollTest/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("scroll-top", "0")
    |> Test.Window.setScrollTop(100)
    |> Test.Html.assertTextOf("scroll-top", "100")
  }
}
