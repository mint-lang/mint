suite "File.fromString" {
  test "it creates a file from a string" {
    let file =
      File.fromString("content", "test.txt", "text/plain")

    File.name(file) == "test.txt"
  }
}

suite "File.mimeType" {
  test "it returns the mime type of the file" {
    let file =
      File.fromString("content", "test.txt", "text/plain")

    File.mimeType(file) == "text/plain"
  }
}

suite "File.name" {
  test "it returns the name of the file" {
    let file =
      File.fromString("content", "test.txt", "text/plain")

    File.name(file) == "test.txt"
  }
}

suite "File.readAsArrayBuffer" {
  test "it reads it as data url" {
    Test.Context.of(File.fromString("content", "test.txt", "text/plain"))
    |> Test.Context.then(File.readAsArrayBuffer)
    |> Test.Context.map(ArrayBuffer.toString)
    |> Test.Context.assertEqual("content")
  }
}

suite "File.readAsDataURL" {
  test "it reads it as data url" {
    Test.Context.of(File.fromString("content", "test.txt", "text/plain"))
    |> Test.Context.then(File.readAsDataURL)
    |> Test.Context.assertEqual("data:text/plain;base64,Y29udGVudA==")
  }
}

suite "File.readAsString" {
  test "it reads it as string" {
    Test.Context.of(File.fromString("content", "test.txt", "text/plain"))
    |> Test.Context.then(File.readAsString)
    |> Test.Context.assertEqual("content")
  }
}

suite "File.size" {
  test "it returns the size of the file" {
    (File.fromString("content", "test.txt", "text/plain")
    |> File.size()) == 7
  }
}
