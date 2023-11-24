suite "Map literal" {
  test "creates a map" {
    Map.size(
      {
        "a" => "b",
        "c" => "d"
      }) == 2
  }

  test "accesses the map" {
    { "a" => "b" }["a"] == Maybe.Just("b")
  }
}

suite "Map with enums" {
  test "Map.set" {
    (Map.empty()
    |> Map.set(Maybe.Just("a"), "a")
    |> Map.set(Maybe.Just("a"), "a")
    |> Map.size()) == 1
  }

  test "Equality" {
    let map1 =
      Map.empty()
      |> Map.set(Maybe.Just("a"), "x")

    let map2 =
      Map.empty()
      |> Map.set(Maybe.Just("a"), "x")

    map1 == map2
  }
}

suite "Map equality" {
  test "maps which are not equal returns false" {
    let map1 =
      Map.empty()
      |> Map.set("a", "x")

    let map2 =
      Map.empty()
      |> Map.set("a", "b")

    map1 != map2
  }

  test "maps which are equal returns true" {
    let map1 =
      Map.empty()
      |> Map.set("a", "b")

    let map2 =
      Map.empty()
      |> Map.set("a", "b")

    map1 == map2
  }
}

suite "Map.set" {
  test "it sets an item" {
    (Map.empty()
    |> Map.set("x", "y")
    |> Map.get("x")
    |> Maybe.withDefault("")) == "y"
  }

  test "it overrides previous value" {
    (Map.empty()
    |> Map.set("x", "y")
    |> Map.set("x", "Z")
    |> Map.get("x")
    |> Maybe.withDefault("")) == "Z"
  }
}

suite "Map.get" {
  test "it gets the value of an item" {
    (Map.empty()
    |> Map.set("a", "b")
    |> Map.get("a")
    |> Maybe.withDefault("")) == "b"
  }

  test "it returns nothing if there is no value" {
    Map.empty()
    |> Map.get("a")
    |> Maybe.isNothing()
  }
}

suite "Map.merge" {
  test "it merges two maps together" {
    let a =
      Map.empty()
      |> Map.set("a", "b")

    let b =
      Map.empty()
      |> Map.set("x", "y")

    (Map.merge(a, b)
    |> Map.get("x")
    |> Maybe.withDefault("")) == "y"
  }

  test "send map has precedence" {
    let a =
      Map.empty()
      |> Map.set("a", "b")

    let b =
      Map.empty()
      |> Map.set("a", "y")

    (Map.merge(a, b)
    |> Map.get("a")
    |> Maybe.withDefault("")) == "y"
  }
}

suite "Map.reduce" {
  test "reduces the map using the given accumulator" {
    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.reduce(
      0,
      (memo : Number, key : String, value : Number) : Number { memo + value })) == 3
  }
}

suite "Map.findKeyBy" {
  test "finds the key using the given function" {
    (Map.empty()
    |> Map.set("a", 0)
    |> Map.set("b", 1)
    |> Map.findKeyBy((value : Number) : Bool { value == 1 })) == Maybe.just("b")
  }

  test "returns nothing if there is no match" {
    (Map.empty()
    |> Map.set("a", 0)
    |> Map.set("b", 3)
    |> Map.findKeyBy((value : Number) : Bool { value == 1 })) == Maybe.nothing()
  }
}

suite "Map.deleteValues" {
  test "it deletes the value from the map" {
    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 1)
    |> Map.deleteValues(1)) == Map.empty()
  }
}

suite "Map.delete" {
  test "it deletes the key from the map" {
    (Map.empty()
    |> Map.set("a", 1)
    |> Map.delete("a")) == Map.empty()
  }
}

suite "Map.values" {
  test "returns the values" {
    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.values()) == [
      1,
      2
    ]
  }
}

suite "Map.keys" {
  test "returns the keys" {
    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.keys()) == [
      "a",
      "b"
    ]
  }
}

suite "Map.sortBy" {
  test "sorts the map by the given function" {
    (Map.empty()
    |> Map.set("a", 2)
    |> Map.set("b", 1)
    |> Map.sortBy((key : String, value : Number) : Number { value })
    |> Map.keys()) == [
      "b",
      "a"
    ]
  }
}

suite "Map.isEmpty" {
  test "returns true for empty" {
    (Map.empty()
    |> Map.isEmpty()) == true
  }

  test "returns false for not empty" {
    (Map.empty()
    |> Map.set("a", "b")
    |> Map.isEmpty()) == false
  }
}

suite "Map.map" {
  test "maps over the items of the map" {
    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.map((key : String, value : Number) : Number { value * 2 })
    |> Map.values()) == [
      2,
      4
    ]
  }
}

suite "Map.has" {
  test "returns if the given key is in the map" {
    (Map.empty()
    |> Map.set("a", 1)
    |> Map.has("a")) == true
  }
}

suite "Map.size" {
  test "returns the number items in the map" {
    (Map.empty()
    |> Map.set("a", 1)
    |> Map.size()) == 1
  }
}

suite "Map.getWithDefault" {
  test "returns value if present" {
    (Map.empty()
    |> Map.set("key", "value")
    |> Map.getWithDefault("key", "fallback")) == "value"
  }

  test "returns fallback if not present" {
    (Map.empty()
    |> Map.getWithDefault("key", "fallback")) == "fallback"
  }
}

suite "Map.entries" {
  test "returns an array of key-value tuple" {
    (Map.empty()
    |> Map.set("a", 100)
    |> Map.set("b", 200)
    |> Map.entries()) == [{"a", 100}, {"b", 200}]
  }
}

suite "Map.fromArray" {
  test "convert an array of tuples into a map" {
    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)) == Map.fromArray([{"a", 1}, {"b", 2}])
  }
}
