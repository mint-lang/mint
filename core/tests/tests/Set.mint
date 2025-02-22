type Set.Test {
  a : String
}

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

  test "uniques the array after converting" {
    (Set.empty()
    |> Set.add("value")) == Set.fromArray(["value", "value", "value"])
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

  test "it does not add the same item to the set" {
    (Set.empty()
    |> Set.add({ a: "test" })
    |> Set.add({ a: "test" })) == Set.fromArray([{ a: "test" }])
  }
}

suite "Set.delete" {
  test "it deletes an item from the set" {
    (Set.empty()
    |> Set.add("value")
    |> Set.delete("value")) == Set.empty()
  }

  test "it deletes an record from the set" {
    (Set.empty()
    |> Set.add({ a: "test" })
    |> Set.delete({ a: "test" })) == Set.empty()
  }
}

suite "Set.map" {
  test "it maps over the items of a set" {
    (Set.fromArray([0])
    |> Set.map(Number.toString)) == Set.fromArray(["0"])
  }
}

suite "Set.size" {
  test "it returns the size of the set" {
    Set.size(Set.fromArray([0, 1, 2])) == 3
  }
}

suite "Set.reduce" {
  test "it reduces a set to a single value" {
    ([1, 2, 3]
    |> Set.fromArray
    |> Set.reduce(0, (memo : Number, item : Number) : Number { memo + item })) == 6
  }
}

suite "Set.union" {
  test "it returns a set which is the union of two sets" {
    let left =
      [1, 2, 3]
      |> Set.fromArray

    let right =
      [3, 4, 5]
      |> Set.fromArray

    (Set.union(left, right)
    |> Set.toArray
    |> Array.sort((a : Number, b : Number) { a - b })) == [1, 2, 3, 4, 5]
  }
}

suite "Set.intersection" {
  test "it returns a set containing the shared elements of two sets" {
    let left =
      [1, 2, 3, 4]
      |> Set.fromArray

    let right =
      [3, 4, 5, 6]
      |> Set.fromArray

    Set.intersection(left, right) == Set.fromArray([3, 4])
  }
}
