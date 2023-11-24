suite "Array equality" {
  test "simple values" {
    ["a", "b"] == ["a", "b"]
  }

  test "different values" {
    [Maybe.just("b")] != [Maybe.just("a")]
  }
}

suite "Array.any" {
  test "returns true if finds any item that matches the predicate" {
    [1, 2, 3, 4, 5, 6]
    |> Array.any((number : Number) : Bool { number == 3 })
  }

  test "returns false if no item matches the predicate" {
    ([1, 2, 3, 4, 5, 6]
    |> Array.any((number : Number) : Bool { number == 9 })) == false
  }
}

suite "Array.append" {
  test "appends the second array before the first" {
    Array.append(["a"], ["b"]) == ["a", "b"]
  }
}

suite "Array.at" {
  test "it returns nothing at 0 if the array is empty" {
    Array.at([], 0) == Maybe.Nothing
  }

  test "it returns nothing index is over the arrays length" {
    Array.at([], 1) == Maybe.Nothing
  }

  test "it returns item at index #1" {
    Array.at([0], 0) == Maybe.Just(0)
  }

  test "it returns item at index #2" {
    Array.at([1, 2, 3], 2) == Maybe.Just(3)
  }
}

suite "Array.compact" {
  test "it flattens an array of maybes" {
    Array.compact(
      [
        Maybe.Just("A"),
        Maybe.Nothing
      ]) == ["A"]
  }
}

suite "Array.concat" {
  test "concatenates multiple arrays together" {
    Array.concat([["a"], ["b"]]) == ["a", "b"]
  }
}

suite "Array.contains" {
  test "returns true if the array contains the exact item" {
    Array.contains(["a", "b"], "a")
  }

  test "returns false if the it does not contain the exact item" {
    Array.contains(["a", "b"], "c") == false
  }
}

suite "Array.delete" {
  test "it removes the item" {
    Array.delete(["a", "b", "c"], "a") == ["b", "c"]
  }
}

suite "Array.deleteAt" {
  test "it deletes the item at the given index" {
    Array.deleteAt(["a", "b", "c"], 0) == ["b", "c"]
  }

  test "it returns array if the index is negative" {
    Array.deleteAt(["a", "b", "c"], -1) == ["a", "b", "c"]
  }

  test "it returns array if the index is bigger then length" {
    Array.deleteAt(["a", "b", "c"], 10) == ["a", "b", "c"]
  }
}

suite "Array.dropEnd" {
  test "drop number of items from the end" {
    Array.dropEnd([1, 2, 3, 4, 5, 6, 7, 8], 2) == [1, 2, 3, 4, 5, 6]
  }

  test "returns array if number of items is negative" {
    Array.dropEnd([1, 2, 3, 4], -2) == [1, 2, 3, 4]
  }

  test "removes all elements if the number is more than the length" {
    Array.dropEnd([1, 2], 4) == []
  }
}

suite "Array.dropStart" {
  test "drop n number of items from the start" {
    Array.dropStart([1, 2, 3, 4, 5, 6, 7, 8], 2) == [3, 4, 5, 6, 7, 8]
  }
}

suite "Array.find" {
  test "finds the first item that matches the predicate" {
    ([1, 2, 3, 4, 5, 6]
    |> Array.find((number : Number) { number == 3 })
    |> Maybe.withDefault(0)) == 3
  }

  test "finds item if it equals to false" {
    ([true, false]
    |> Array.find((item : Bool) { item == false })
    |> Maybe.withDefault(true)) == false
  }
}

suite "Array.findByAndMap" {
  test "finds the first item that matches the predicate and returns the second value of the tuple" {
    ([1, 2, 3, 4, 5, 6]
    |> Array.findByAndMap((number : Number) { {number == 3, "Three"} })
    |> Maybe.withDefault("")) == "Three"
  }
}

suite "Array.first" {
  test "returns nothing for empty array" {
    []
    |> Array.first()
    |> Maybe.isNothing()
  }

  test "returns just(a) for non-empty array" {
    ["a", "b"]
    |> Array.first()
    |> Maybe.isJust()
  }

  test "returns the first item of non-empty array" {
    (["a", "b"]
    |> Array.first()
    |> Maybe.withDefault("")) == "a"
  }
}

suite "Array.firstWithDefault" {
  test "returns the first item if exists" {
    (["a", "b", "c"]
    |> Array.firstWithDefault("")) == "a"
  }

  test "returns the default value if the item does not exists" {
    (Array.firstWithDefault([], "")) == ""
  }
}

suite "Array.flatMap" {
  test "maps over a nested array and flattens" {
    let result =
      [[3, 1], [2, 0], [5]]
      |> Array.flatMap(
        (n : Array(Number)) : Array(Number) {
          [
            Array.max(n)
            |> Maybe.withDefault(0)
          ]
        })

    result == [3, 2, 5]
  }
}

suite "Array.groupsOf" {
  test "group into items of specified size" {
    let result =
      [1, 2, 3, 4, 5, 6, 7, 8]
      |> Array.groupsOf(2)

    (result == [
      [1, 2],
      [3, 4],
      [5, 6],
      [7, 8]
    ])
  }
}

suite "Array.groupsOfFromEnd" {
  test "group into items of specified size" {
    let result =
      Array.groupsOfFromEnd([1, 2, 3, 4, 5, 6, 7], 2)

    (result == [
      [1],
      [2, 3],
      [4, 5],
      [6, 7]
    ])
  }
}

suite "Array.indexBy" {
  test "it returns the index of the item" {
    Array.indexBy(["a", "b", "c"], "a", (item : String) : String { item }) == 0
  }
}

suite "Array.indexOf" {
  test "it returns the index of the item" {
    Array.indexOf(["a", "b", "c"], "c") == Maybe.Just(2)
  }

  test "it returns the index of an enum" {
    Array.indexOf([Http.Error.Aborted], Http.Error.Aborted) == Maybe.Just(0)
  }
}

suite "Array.insertAt" {
  test "it inserts item at front if the position below zero" {
    Array.insertAt(["b", "c"], "a", -10) == ["a", "b", "c"]
  }

  test "it inserts item at front if the position zero" {
    Array.insertAt(["b", "c"], "a", 0) == ["a", "b", "c"]
  }

  test "it inserts item at the given position" {
    Array.insertAt(["b", "c"], "a", 1) == ["b", "a", "c"]
  }

  test "it inserts item at the given position2" {
    Array.insertAt(["b", "c"], "a", 2) == ["b", "c", "a"]
  }

  test "it inserts item at back if the position is greater then " \
  "the length" {
    Array.insertAt(["b", "c"], "a", 10) == ["b", "c", "a"]
  }
}

suite "Array.intersperse" {
  test "inserts the separator between items" {
    (["a", "b", "c", "d"]
    |> Array.intersperse("|")
    |> String.join("")) == "a|b|c|d"
  }
}

suite "Array.isEmpty" {
  test "returns true for empty array" {
    Array.isEmpty([])
  }

  test "returns false for non-empty array" {
    Array.isEmpty(["a"]) == false
  }
}

suite "Array.last" {
  test "returns nothing for empty array" {
    []
    |> Array.last()
    |> Maybe.isNothing()
  }

  test "returns just(a) for non-empty array" {
    ["a", "b"]
    |> Array.last()
    |> Maybe.isJust()
  }

  test "returns the last item of non-empty array" {
    (["a", "b"]
    |> Array.last()
    |> Maybe.withDefault("")) == "b"
  }
}

suite "Array.lastWithDefault" {
  test "returns the first item if exists" {
    (["a", "b", "c"]
    |> Array.lastWithDefault("")) == "c"
  }

  test "returns the default value if the item does not exists" {
    (Array.lastWithDefault([], "")) == ""
  }
}

suite "Array.map" {
  test "maps over the items of the array" {
    (["A", "B"]
    |> Array.map(String.toLowerCase)
    |> Array.first()
    |> Maybe.withDefault("")) == "a"
  }
}

suite "Array.mapWithIndex" {
  test "maps over the items and their indexes of the array" {
    (["A", "B"]
    |> Array.mapWithIndex(
      (item : String, index : Number) : String { item + Number.toString(index) })
    |> Array.first()
    |> Maybe.withDefault("")) == "A0"
  }
}

suite "Array.max" {
  test "it returns the largest number" {
    Array.max([1, 2, 3]) == Maybe.just(3)
  }

  test "it returns nothing" {
    Array.max([]) == Maybe.nothing()
  }
}

suite "Array.min" {
  test "it returns smallest number" {
    Array.min([1, 2, 3]) == Maybe.just(1)
  }

  test "it returns nothing" {
    Array.min([]) == Maybe.nothing()
  }
}

suite "Array.move" {
  test "it returns the array as is if from equals to to" {
    Array.move(["A", "B", "C"], 0, 0) == ["A", "B", "C"]
  }

  test "it returns the array as is if from is negative" {
    Array.move(["A", "B", "C"], -1, 0) == ["A", "B", "C"]
  }

  test "it returns the array as is if from is too big" {
    Array.move(["A", "B", "C"], 10, 0) == ["A", "B", "C"]
  }

  test "it moves the item to the front if to is negative" {
    Array.move(["A", "B", "C"], 2, -1) == ["C", "A", "B"]
  }

  test "it moves the item to the back if to is too big" {
    Array.move(["A", "B", "C"], 0, 10) == ["B", "C", "A"]
  }

  test "it moves the item #1" {
    Array.move(["A", "B", "C"], 1, 0) == ["B", "A", "C"]
  }

  test "it moves the item #2" {
    Array.move(["A", "B", "C", "D", "E"], 0, 2) == ["B", "C", "A", "D", "E"]
  }

  test "it moves the item #2" {
    Array.move(["A", "B", "C", "D", "E"], 2, 0) == ["C", "A", "B", "D", "E"]
  }
}

suite "Array.push" {
  test "appends item" {
    ([]
    |> Array.push("a")
    |> Array.size()) == 1
  }

  test "appends item to the end" {
    (["x", "y", "z"]
    |> Array.push("a")
    |> Array.last()
    |> Maybe.withDefault("")) == "a"
  }
}

suite "Array.range" {
  test "returns an array of numbers for the given range" {
    (Array.range(0, 10)
    |> Array.map(Number.toString)
    |> String.join("")) == "012345678910"
  }
}

suite "Array.reduce" {
  test "it reduces an array to a single value" {
    Array.reduce(
      [1, 2, 3],
      0,
      (memo : Number, item : Number) : Number { memo + item }) == 6
  }
}

suite "Array.reduceEnd" {
  test "it reduces an array to a single value from the right" {
    Array.reduceEnd(
      [1, 2, 3],
      0,
      (memo : Number, item : Number) : Number { memo + item }) == 6
  }
}

suite "Array.reject" {
  test "keeps items that match that does not predicate" {
    ([1, 2, 3, 4, 5]
    |> Array.reject(Number.isOdd)
    |> Array.size()) == 2
  }
}

suite "Array.reverse" {
  test "reverses an array" {
    (["x", "y"]
    |> Array.reverse()
    |> Array.first()
    |> Maybe.withDefault("")) == "y"
  }
}

suite "Array.reverseIf" {
  test "reverses an array if the condition is true" {
    (["x", "y"]
    |> Array.reverseIf(true)
    |> Array.first()
    |> Maybe.withDefault("")) == "y"
  }
}

suite "Array.sample" {
  test "it returns nothing if the array is empty" {
    Array.sample([]) == Maybe.nothing()
  }

  test "it returns the only item if the array" {
    Array.sample([0]) == Maybe.just(0)
  }

  test "it returns an item from the array" {
    Array.sample([0, 1])
    |> Maybe.isJust()
  }
}

suite "Array.select" {
  test "keeps items that match that predicate" {
    ([1, 2, 3, 4, 5]
    |> Array.select(Number.isOdd)
    |> Array.size()) == 3
  }
}

suite "Array.setAt" {
  test "it sets the item at the given index" {
    Array.setAt([1, 2, 3], 2, 5) == [1, 2, 5]
  }
}

suite "Array.size" {
  test "returns 0 for empty array" {
    Array.size([]) == 0
  }

  test "returns 1 for an array with 1 item" {
    Array.size([""]) == 1
  }

  test "returns 5 for an array with 5 items" {
    Array.size(["", "", "", "", ""]) == 5
  }
}

suite "Array.slice" {
  test "returns empty array for empty array" {
    []
    |> Array.slice(0, 0)
    |> Array.isEmpty()
  }

  test "returns part of the array" {
    ([1, 2, 3, 4, 5]
    |> Array.slice(1, 3)
    |> Array.map(Number.toString)
    |> String.join("")) == "23"
  }
}

suite "Array.sort" {
  test "sorts the array based on predicate function" {
    ([
      3,
      2,
      1
    ]
    |> Array.sort((a : Number, b : Number) : Number { a - b })
    |> Array.map(Number.toString)
    |> String.join("")) == "123"
  }
}

suite "Array.sortBy" {
  test "sorts the array based on predicate function" {
    ([
      3,
      2,
      1
    ]
    |> Array.sortBy((a : Number) : Number { a })
    |> Array.map(Number.toString)
    |> String.join("")) == "123"
  }
}

suite "Array.sum" {
  test "it sums up the array" {
    Array.sum([1, 2, 3]) == 6
  }
}

suite "Array.sumBy" {
  test "it sums up the array by using the function" {
    Array.sumBy([1, 2, 3], (value : Number) : Number { value }) == 6
  }
}

suite "Array.swap" {
  test "it swaps items" {
    Array.swap(["a", "b"], 0, 1) == ["b", "a"]
  }

  test "it returns array if index is negative #1" {
    Array.swap(["a", "b"], -1, 1) == [
      "a",
      "b"
    ]
  }

  test "it returns array if index is negative #2" {
    Array.swap(["a", "b"], 0, -1) == ["a", "b"]
  }

  test "it returns array if index is bigger then the length #1" {
    Array.swap(["a", "b"], 2, 0) == ["a", "b"]
  }

  test "it returns array if index is bigger then the length #2" {
    Array.swap(["a", "b"], 0, 2) == ["a", "b"]
  }
}

suite "Array.takeEnd" {
  test "take n number of items" {
    let result =
      [1, 2, 3, 4, 5, 6, 7, 8]
      |> Array.takeEnd(2)

    result == [7, 8]
  }
}

suite "Array.takeStart" {
  test "take n number of items" {
    let result =
      [1, 2, 3, 4, 5, 6, 7, 8]
      |> Array.takeStart(2)

    result == [1, 2]
  }
}

suite "Array.uniq" {
  test "removes duplicated from the array" {
    Array.uniq([1, 2, 3, 1, 2, 3]) == [1, 2, 3]
  }
}

suite "Array.unshift" {
  test "it pushes a new item at the head of the array." {
    Array.unshift([3, 4], 2) == [2, 3, 4]
  }
}

suite "Array.updateAt" {
  test "it updates the item at the given index" {
    Array.updateAt([0, 1, 2], 2, (number : Number) : Number { number + 2 }) == [0, 1, 4]
  }
}
