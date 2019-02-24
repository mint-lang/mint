suite "Storage.Session.set" {
  test "returns void for successfull set" {
    Storage.Session.set("test", "value")
    |> Result.isOk()
  }

  test "sets the given value at the given key" {
    try {
      Storage.Session.set("test", "test")

      value =
        Storage.Session.get("test")

      (value == "test")
    } catch Storage.Error => error {
      false
    }
  }

  test "it returns error if over the qouta" {
    try {
      result =
        Storage.Session.set("test", String.repeat(10000000, "test"))
        |> Result.withError(Storage.Error::Unkown)

      (result == Storage.Error::QuotaExceeded)
    }
  }
}

suite "Storage.Session.get" {
  test "it returns the value if exists" {
    try {
      Storage.Session.set("test", "test")

      value =
        Storage.Session.get("test")

      (value == "test")
    } catch Storage.Error => error {
      false
    }
  }

  test "it returns nothing if the key does not exists" {
    try {
      value =
        Storage.Session.get("test")

      false
    } catch Storage.Error => error {
      true
    }
  }
}

suite "Storage.Session.clear" {
  test "it clears all items" {
    try {
      Storage.Session.set("test", "test")

      initialSize =
        Storage.Session.size()

      Storage.Session.clear()

      afterSize =
        Storage.Session.size()

      (initialSize == 1 && afterSize == 0)
    } catch Storage.Error => error {
      false
    }
  }
}

suite "Storage.Session.remove" {
  test "it removes the item with the specified key" {
    try {
      Storage.Session.set("test", "test")

      initialSize =
        Storage.Session.size()

      Storage.Session.remove("test")

      afterSize =
        Storage.Session.size()

      (initialSize == 1 && afterSize == 0)
    } catch Storage.Error => error {
      false
    }
  }
}

suite "Storage.Session.size" {
  test "it returns the number of elements in the storage" {
    try {
      Storage.Session.set("a", "0")
      Storage.Session.set("b", "1")
      Storage.Session.set("c", "2")

      size =
        Storage.Session.size()

      (size == 3)
    } catch Storage.Error => error {
      false
    }
  }
}

suite "Storage.Session.keys" {
  test "it returns the keys of elements in the storage" {
    try {
      Storage.Session.set("c", "2")
      Storage.Session.set("a", "0")
      Storage.Session.set("b", "1")

      keys =
        Storage.Session.keys()

      (String.join("", keys) == "abc")
    } catch Storage.Error => error {
      false
    }
  }
}
