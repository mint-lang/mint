suite "Set.toArray" {
  test "it converts a set to an array" {
    (Set.empty()
    |> Set.add("value")
    |> Set.toArray()) == ["value"]
  }
}

suite "Set.fromArray" {
  test "it converts an array to a set" {
    (Set.empty()
    |> Set.add("value")) == Set.fromArray(["value"])
  }
}

suite "Set.toArray" {
  test "it converts a set to an array" {
    (Set.empty()
    |> Set.add("value")
    |> Set.toArray()) == ["value"]
  }
}

suite "Set.has" {
  test "it returns true if the item exists in the set" {
    (Set.empty()
    |> Set.add(Maybe.just("value"))
    |> Set.has(Maybe.just("value"))) == true
  }

  test "it returns false if the itme does not exists in the set" {
    (Set.empty()
    |> Set.has("x")) == false
  }
}

suite "Set.add" {
  test "it adds an item to the set" {
    (Set.empty()
    |> Set.add("value")) == Set.fromArray(["value"])
  }
}

suite "Set.delete" {
  test "it deltes an item from the set" {
    (Set.empty()
    |> Set.add("value")
    |> Set.delete("value")) == Set.empty()
  }
}

suite "Set.map" {
  test "it maps over the items of a set" {
    (Set.fromArray([0])
    |> Set.map(Number.toString)) == Set.fromArray(["0"])
  }
}
