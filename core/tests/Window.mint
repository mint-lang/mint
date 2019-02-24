component ScrollTest {
  use Provider.Scroll { scrolls = (event : Html.Event) : Void { `this.forceUpdate()` } }

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

      (Window.href() == "http://localhost:" + url.port + "/blah")
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

      (Window.title() == "Test")
    }
  }
}

suite "Window.url" {
  test "returns the current url" {
    try {
      url =
        Window.url()

      (url.hostname == "localhost")
    }
  }
}

suite "Window.href" {
  test "returns the current url as string" {
    try {
      url =
        Window.url()

      (Window.href() == "http://localhost:" + url.port + "/")
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
    Window.scrollWidth() == `document.body.scrollWidth`
  }

  test "returns the scrollable width when overflown" {
    with Test.Html {
      <ScrollTest/>
      |> start()
      |> Test.Context.then(
        (subject : Dom.Element) : Promise(Never, Dom.Element) { Timer.nextFrame(subject) })
      |> assertTextOf("scroll-width", "3008")
    }
  }
}

suite "Window.scrollHeight" {
  test "returns the scrollable height" {
    Window.scrollHeight() == `document.body.scrollHeight`
  }

  test "returns the scrollable height when overflown" {
    with Test.Html {
      <ScrollTest/>
      |> start()
      |> assertTextOf("scroll-height", "3016")
    }
  }
}

suite "Window.scrollLeft" {
  test "returns the left scroll position" {
    Window.scrollLeft() == `document.body.scrollLeft`
  }

  test "returns the left scroll position when scrolled" {
    with Test.Html {
      with Test.Window {
        <ScrollTest/>
        |> start()
        |> setScrollLeft(100)
        |> assertTextOf("scroll-left", "100")
      }
    }
  }
}

suite "Window.scrollTop" {
  test "returns the left scroll position" {
    Window.scrollTop() == `document.body.scrollTop`
  }

  test "returns the left scroll position when scrolled" {
    with Test.Html {
      with Test.Window {
        <ScrollTest/>
        |> start()
        |> setScrollTop(100)
        |> assertTextOf("scroll-top", "100")
      }
    }
  }
}

suite "Window.setScrollLeft" {
  test "sets the left scroll position" {
    with Test.Html {
      with Test.Window {
        <ScrollTest/>
        |> start()
        |> assertTextOf("scroll-left", "0")
        |> setScrollLeft(100)
        |> assertTextOf("scroll-left", "100")
      }
    }
  }
}

suite "Window.setScrollTop" {
  test "sets the top scroll position" {
    with Test.Html {
      with Test.Window {
        <ScrollTest/>
        |> start()
        |> assertTextOf("scroll-top", "0")
        |> setScrollTop(100)
        |> assertTextOf("scroll-top", "100")
      }
    }
  }
}
