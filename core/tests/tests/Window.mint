component ScrollTest {
  use Provider.Scroll { scrolls = (event : Html.Event) : Promise(Never, Void) { `this.forceUpdate()` } }

  style base {
    height: 3000px;
    width: 3000px;
  }

  fun componentDidMount : Void {
    `this.forceUpdate()`
  }

  fun render : Html {
    <div::base>
      <scroll-width>
        <{ Number.toString(Window.scrollWidth()) }>
      </scroll-width>

      <scroll-height>
        <{ Number.toString(Window.scrollHeight()) }>
      </scroll-height>

      <scroll-left>
        <{ Number.toString(Window.scrollLeft()) }>
      </scroll-left>

      <scroll-top>
        <{ Number.toString(Window.scrollTop()) }>
      </scroll-top>
    </div>
  }
}

suite "Window.navigate" {
  test "it navigates to the given url with push state" {
    try {
      url =
        Window.url()

      Window.navigate("/blah")

      Window.href() == "http://127.0.0.1:#{url.port}/blah"
    }
  }
}

suite "Window.title" {
  test "returns the current title" {
    Window.title() == ""
  }
}

suite "Window.setTitle" {
  test "sets the windows title" {
    try {
      Window.setTitle("Test")

      Window.title() == "Test"
    }
  }
}

suite "Window.url" {
  test "returns the current url" {
    try {
      url =
        Window.url()

      url.hostname == "127.0.0.1"
    }
  }
}

suite "Window.href" {
  test "returns the current url as string" {
    try {
      url =
        Window.url()

      Window.href() == "http://127.0.0.1:#{url.port}/"
    }
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
    |> Test.Context.then(
      (subject : Dom.Element) : Promise(Never, Dom.Element) { Timer.nextFrame(subject) })
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
