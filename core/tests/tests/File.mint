suite "File.fromString" {
  test "it creates a file from a string" {
    try {
      file =
        File.fromString("content", "test.txt", "text/plain")

      File.name(file) == "test.txt"
    }
  }
}

suite "File.mimeType" {
  test "it returns the mime type of the file" {
    try {
      file =
        File.fromString("content", "test.txt", "text/plain")

      File.mimeType(file) == "text/plain"
    }
  }
}

suite "File.name" {
  test "it returns the name of the file" {
    try {
      file =
        File.fromString("content", "test.txt", "text/plain")

      File.name(file) == "test.txt"
    }
  }
}

suite "File.readAsDataURL" {
  test "it reads it as data url" {
    with Test.Context {
      of(File.fromString("content", "test.txt", "text/plain"))
      |> then(File.readAsDataURL)
      |> assertEqual("data:text/plain;base64,Y29udGVudA==")
    }
  }
}

suite "File.readAsString" {
  test "it reads it as string" {
    with Test.Context {
      of(File.fromString("content", "test.txt", "text/plain"))
      |> then(File.readAsString)
      |> assertEqual("content")
    }
  }
}

suite "File.size" {
  test "it returns the size of the file" {
    (File.fromString("content", "test.txt", "text/plain")
    |> File.size()) == 7
  }
}
