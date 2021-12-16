suite "File.readAsString" {
  test "it reads it as string" {
    File.fromString("content", "test.txt", "text/plain")
      .of()
      .then(File.readAsString)
      .assertEqual("content")
  }
}

suite "File.readAsDataURL" {
  test "it reads it as data url" {
    File.fromString("content", "test.txt", "text/plain")
      .of()
      .then(File.readAsDataURL)
      .assertEqual("data:text/plain;base64,Y29udGVudA==")
  }
}

suite "File.name" {
  test "it returns the name of the file" {
    File.fromString("content", "test.txt", "text/plain").name() == "test.txt"
  }
}

suite "File.type" {
  test "it returns the mime type of the file" {
    File.fromString("content", "test.txt", "text/plain").mimeType() == "text/plain"
  }
}

suite "File.size" {
  test "it returns the size of the file" {
    File.fromString("content", "test.txt", "text/plain").size() == 7
  }
}
