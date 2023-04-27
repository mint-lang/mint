suite "Storage.Session.set" {
  test "returns void for successful set" {
    Storage.Session.set("test", "value")
    |> Result.isOk()
  }

  test "sets the given value at the given key" {
    Storage.Session.set("test", "test")

    let value =
      Storage.Session.get("test")
      |> Result.withDefault("")

    value == "test"
  }

  test "it returns error if over the qouta" {
    let result =
      Storage.Session.set("test", String.repeat("test", 10000000))
      |> Result.withError(Storage.Error::Unknown)

    result == Storage.Error::QuotaExceeded
  }
}

suite "Storage.Session.get" {
  test "it returns the value if exists" {
    Storage.Session.set("test", "test")

    let value =
      Storage.Session.get("test")
      |> Result.withDefault("")

    value == "test"
  }

  test "it returns nothing if the key does not exists" {
    case Storage.Session.get("test") {
      Result::Ok(value) => false
      Result::Err => true
    }
  }
}

suite "Storage.Session.clear" {
  test "it clears all items" {
    Storage.Session.set("test", "test")

    let initialSize =
      Storage.Session.size()
      |> Result.withDefault(-1)

    Storage.Session.clear()

    let afterSize =
      Storage.Session.size()
      |> Result.withDefault(-1)

    (initialSize == 1 && afterSize == 0)
  }
}

suite "Storage.Session.delete" {
  test "it deletes the item with the specified key" {
    Storage.Session.set("test", "test")

    let initialSize =
      Storage.Session.size()
      |> Result.withDefault(-1)

    Storage.Session.delete("test")

    let afterSize =
      Storage.Session.size()
      |> Result.withDefault(-1)

    (initialSize == 1 && afterSize == 0)
  }
}

suite "Storage.Session.size" {
  test "it returns the number of elements in the storage" {
    Storage.Session.set("a", "0")
    Storage.Session.set("b", "1")
    Storage.Session.set("c", "2")

    let size =
      Storage.Session.size()
      |> Result.withDefault(-1)

    size == 3
  }
}

suite "Storage.Session.keys" {
  test "it returns the keys of elements in the storage" {
    Storage.Session.set("c", "2")
    Storage.Session.set("a", "0")
    Storage.Session.set("b", "1")

    let keys =
      Storage.Session.keys()
      |> Result.withDefault([])

    String.join(keys, "") == "abc"
  }
}
