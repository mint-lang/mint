suite "Url.parse" {
  test "parses an url" {
    try {
      url =
        Url.parse("http://www.google.com")

      url.host == "www.google.com"
    }
  }

  test "parses an url" {
    try {
      url =
        Url.parse("")

      url.path == "/"
    }
  }
}

suite "Url.createObjectUrlFromFile" {
  test "it creates an url from a file" {
    (File.fromString("Content", "test.html", "text/html")
    |> Url.createObjectUrlFromFile()) != ""
  }
}

suite "Url.createObjectUrlFromString" {
  test "it creates an url from a file" {
    Url.createObjectUrlFromString("Content", "text/html") != ""
  }
}

suite "Url.revokeObjectUrl" {
  test "it revokes the given url" {
    try {
      Url.createObjectUrlFromString("Content", "text/html")
      |> Url.revokeObjectUrl()

      true
    }
  }
}
