suite "Storage.Local.set" {
  test "returns void for successful set" {
    Storage.Local.set("test", "value")
    |> Result.isOk()
  }

  test "sets the given value at the given key" {
    Storage.Local.set("test", "test")

    case (Storage.Local.get("test")) {
      Result::Ok(value) => value == "test"
      Result::Err => false
    }
  }

  test "it returns error if over the qouta" {
    result =
      Storage.Local.set("test", String.repeat(10000000, "test"))
      |> Result.withError(Storage.Error::Unknown)

    result == Storage.Error::QuotaExceeded
  }
}

suite "Storage.Local.get" {
  test "it returns the value if exists" {
    Storage.Local.set("test", "test")

    case (Storage.Local.get("test")) {
      Result::Ok(value) => value == "test"
      Result::Err => false
    }
  }

  test "it returns nothing if the key does not exists" {
    case (Storage.Local.get("test")) {
      Result::Ok(value) => false
      Result::Err => true
    }
  }
}

suite "Storage.Local.clear" {
  test "it clears all items" {
    Storage.Local.set("test", "test")

    initialSize =
      Storage.Local.size()
      |> Result.withDefault(-1)

    Storage.Local.clear()

    afterSize =
      Storage.Local.size()
      |> Result.withDefault(-1)

    (initialSize == 1 && afterSize == 0)
  }
}

suite "Storage.Local.remove" {
  test "it removes the item with the specified key" {
    Storage.Local.set("test", "test")

    initialSize =
      Storage.Local.size()
      |> Result.withDefault(-1)

    Storage.Local.remove("test")

    afterSize =
      Storage.Local.size()
      |> Result.withDefault(-1)

    (initialSize == 1 && afterSize == 0)
  }
}

suite "Storage.Local.size" {
  test "it returns the number of elements in the storage" {
    Storage.Local.set("a", "0")
    Storage.Local.set("b", "1")
    Storage.Local.set("c", "2")

    size =
      Storage.Local.size()
      |> Result.withDefault(0)

    size == 3
  }
}

suite "Storage.Local.keys" {
  test "it returns the keys of elements in the storage" {
    Storage.Local.set("c", "2")
    Storage.Local.set("a", "0")
    Storage.Local.set("b", "1")

    keys =
      Storage.Local.keys()
      |> Result.withDefault([])

    String.join("", keys) == "abc"
  }
}
