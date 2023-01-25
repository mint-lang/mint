suite "Url.parse" {
  test "parses an url" {
    Url.parse("http://www.google.com").host == "www.google.com"
  }

  test "parses an url" {
    Url.parse("").path == "/"
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
    Url.createObjectUrlFromString("Content", "text/html")
    |> Url.revokeObjectUrl()

    true
  }
}
