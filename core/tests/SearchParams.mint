suite "SearchParams.empty" {
  test "returns an empty SearchParams" {
    SearchParams.empty() == SearchParams.empty()
  }
}

suite "SearchParams.fromString" {
  test "returns a search params from a string" {
    "a=b&c=d"
    |> SearchParams.fromString()
    |> SearchParams.has("a")
  }
}

suite "SearchParams.get" {
  test "returns the value if key exists" {
    ("a=b&c=d"
    |> SearchParams.fromString()
    |> SearchParams.get("a")) == Maybe.just("b")
  }

  test "returns nothig if key does not exists" {
    ("a=b&c=d"
    |> SearchParams.fromString()
    |> SearchParams.get("x")) == Maybe.nothing()
  }
}

suite "SearchParams.has" {
  test "returns true if key exists" {
    "a=b&c=d"
    |> SearchParams.fromString()
    |> SearchParams.has("a")
  }

  test "returns false if key does not exists" {
    ("a=b&c=d"
    |> SearchParams.fromString()
    |> SearchParams.has("x")) == false
  }
}

suite "SearchParams.delete" {
  test "removes key if exists" {
    ("a=b&c=d"
    |> SearchParams.fromString()
    |> SearchParams.delete("a")
    |> SearchParams.get("a")) == Maybe.nothing()
  }
}

suite "SearchParams.set" {
  test "sets the given key to the given value" {
    (SearchParams.empty()
    |> SearchParams.set("a", "b")
    |> SearchParams.get("a")) == Maybe.just("b")
  }
}

suite "SearchParams.append" {
  test "adds a new parameter at the end of the search params" {
    (SearchParams.empty()
    |> SearchParams.set("a", "b")
    |> SearchParams.set("b", "c")
    |> SearchParams.append("a", "b")
    |> SearchParams.toString()) == "a=b&b=c&a=b"
  }
}

suite "SearchParams.toString" {
  test "returns the string representation of the search params" {
    (SearchParams.empty()
    |> SearchParams.set("a", "b")
    |> SearchParams.set("b", "c")
    |> SearchParams.toString()) == "a=b&b=c"
  }
}
