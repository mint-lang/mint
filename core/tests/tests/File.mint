suite "File.readAsString" {
  test "it reads it as string" {
    Test.Context.of(File.fromString("content", "test.txt", "text/plain"))
    |> Test.Context.then(File.readAsString)
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

suite "File.name" {
  test "it returns the name of the file" {
    (File.fromString("content", "test.txt", "text/plain")
    |> File.name()) == "test.txt"
  }
}

suite "File.type" {
  test "it returns the mime type of the file" {
    (File.fromString("content", "test.txt", "text/plain")
    |> File.mimeType()) == "text/plain"
  }
}

suite "File.size" {
  test "it returns the size of the file" {
    (File.fromString("content", "test.txt", "text/plain")
    |> File.size()) == 7
  }
}
