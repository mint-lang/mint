suite "Array equality" {
  test "simple values" {
    [
      "a",
      "b"
    ] == [
      "a",
      "b"
    ]
  }

  test "different values" {
    [Maybe.just("b")] != [Maybe.just("a")]
  }
}

suite "Array.first" {
  test "returns nothing for empty array" {
    []
    |> Array.first()
    |> Maybe.isNothing()
  }

  test "returns just(a) for non-empty array" {
    [
      "a",
      "b"
    ]
    |> Array.first()
    |> Maybe.isJust()
  }

  test "returns the first item of non-empty array" {
    ([
      "a",
      "b"
    ]
    |> Array.first()
    |> Maybe.withDefault("")) == "a"
  }
}

suite "Array.firstWithDefault" {
  test "returns the first item if exists" {
    ([
      "a",
      "b",
      "c"
    ]
    |> Array.firstWithDefault("")) == "a"
  }

  test "returns the default value if the item does not exists" {
    (Array.firstWithDefault("", [])) == ""
  }
}

suite "Array.last" {
  test "returns nothing for empty array" {
    []
    |> Array.last()
    |> Maybe.isNothing()
  }

  test "returns just(a) for non-empty array" {
    [
      "a",
      "b"
    ]
    |> Array.last()
    |> Maybe.isJust()
  }

  test "returns the last item of non-empty array" {
    ([
      "a",
      "b"
    ]
    |> Array.last()
    |> Maybe.withDefault("")) == "b"
  }
}

suite "Array.lastWithDefault" {
  test "returns the first item if exists" {
    ([
      "a",
      "b",
      "c"
    ]
    |> Array.lastWithDefault("")) == "c"
  }

  test "returns the default value if the item does not exists" {
    (Array.lastWithDefault("", [])) == ""
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
    Array.size([
      "",
      "",
      "",
      "",
      ""
    ]) == 5
  }
}

suite "Array.push" {
  test "appends item" {
    ([]
    |> Array.push("a")
    |> Array.size()) == 1
  }

  test "appends item to the end" {
    ([
      "x",
      "y",
      "z"
    ]
    |> Array.push("a")
    |> Array.last()
    |> Maybe.withDefault("")) == "a"
  }
}

suite "Array.reverse" {
  test "reverses an array" {
    ([
      "x",
      "y"
    ]
    |> Array.reverse()
    |> Array.first()
    |> Maybe.withDefault("")) == "y"
  }
}

suite "Array.map" {
  test "maps over the items of the array" {
    ([
      "A",
      "B"
    ]
    |> Array.map(String.toLowerCase)
    |> Array.first()
    |> Maybe.withDefault("")) == "a"
  }
}

suite "Array.mapWithIndex" {
  test "maps over the items and their indexes of the array" {
    ([
      "A",
      "B"
    ]
    |> Array.mapWithIndex(
      (item : String, index : Number) : String { item + Number.toString(index) })
    |> Array.first()
    |> Maybe.withDefault("")) == "A0"
  }
}

suite "Array.select" {
  test "keeps items that match that predicate" {
    ([
      1,
      2,
      3,
      4,
      5
    ]
    |> Array.select(Number.isOdd)
    |> Array.size()) == 3
  }
}

suite "Array.reject" {
  test "keeps items that match that does not predicate" {
    ([
      1,
      2,
      3,
      4,
      5
    ]
    |> Array.reject(Number.isOdd)
    |> Array.size()) == 2
  }
}

suite "Array.find" {
  test "finds the first item that matches the predicate" {
    ([
      1,
      2,
      3,
      4,
      5,
      6
    ]
    |> Array.find((number : Number) : Bool { number == 3 })
    |> Maybe.withDefault(0)) == 3
  }

  test "finds item if it equals to false" {
    ([
      true,
      false
    ]
    |> Array.find((item : Bool) : Bool { item == false })
    |> Maybe.withDefault(true)) == false
  }
}

suite "Array.any" {
  test "returns true if finds any item that matches the predicat" \
  "e" {
    [
      1,
      2,
      3,
      4,
      5,
      6
    ]
    |> Array.any((number : Number) : Bool { number == 3 })
  }

  test "returns false if no item matches the predicate" {
    ([
      1,
      2,
      3,
      4,
      5,
      6
    ]
    |> Array.any((number : Number) : Bool { number == 9 })) == false
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

suite "Array.slice" {
  test "returns empty array for empty array" {
    []
    |> Array.slice(0, 0)
    |> Array.isEmpty()
  }

  test "returns part of the array" {
    ([
      1,
      2,
      3,
      4,
      5
    ]
    |> Array.slice(1, 3)
    |> Array.map(Number.toString)
    |> String.join("")) == "23"
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

suite "Array.intersperse" {
  test "inserts the separator between items" {
    ([
      "a",
      "b",
      "c",
      "d"
    ]
    |> Array.intersperse("|")
    |> String.join("")) == "a|b|c|d"
  }
}

suite "Array.concat" {
  test "concatenates multiple arrays together" {
    Array.concat([
      ["a"],
      ["b"]
    ]) == [
      "a",
      "b"
    ]
  }
}

suite "Array.append" {
  test "appends the second array before the first" {
    Array.append(["a"], ["b"]) == [
      "a",
      "b"
    ]
  }
}

suite "Array.contains" {
  test "returns true if the array contains the exact item" {
    [
      "a",
      "b"
    ]
    |> Array.contains("a")
  }

  test "returns false if the it does not contain the exact item" {
    ([
      "a",
      "b"
    ]
    |> Array.contains("c")) == false
  }
}

suite "Array.range" {
  test "returns an array of numbers for the given range" {
    (Array.range(0, 10)
    |> Array.map(Number.toString)
    |> String.join("")) == "012345678910"
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
    Array.sample([
      0,
      1
    ])
    |> Maybe.isJust()
  }
}

suite "Array.at" {
  test "it returns nothing at 0 if the array is empty" {
    Array.at(0, []) == Maybe.nothing()
  }

  test "it returns nothing index is over the arrays length" {
    Array.at(1, []) == Maybe.nothing()
  }

  test "it returns item at index #1" {
    Array.at(0, [0]) == Maybe.just(0)
  }

  test "it returns item at index #2" {
    Array.at(2, [
      1,
      2,
      3
    ]) == Maybe.just(3)
  }
}

suite "Array.reduce" {
  test "it reduces an array to a single value" {
    Array.reduce(
      0,
      (memo : Number, item : Number) : Number { memo + item },
      [
        1,
        2,
        3
      ]) == 6
  }
}

suite "Array.reduceRight" {
  test "it reduces an array to a single value from the right" {
    Array.reduceRight(
      0,
      (memo : Number, item : Number) : Number { memo + item },
      [
        1,
        2,
        3
      ]) == 6
  }
}

suite "Array.flatMap" {
  test "maps over a nested array and flattens" {
    try {
      result =
        [
          [
            3,
            1
          ],
          [
            2,
            0
          ],
          [5]
        ]
        |> Array.flatMap(
          (n : Array(Number)) : Array(Number) { [Array.max(n)] })

      (result == [
        3,
        2,
        5
      ])
    }
  }
}

suite "Array.take" {
  test "take n number of items" {
    try {
      result =
        [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8
        ]
        |> Array.take(2)

      (result == [
        1,
        2
      ])
    }
  }
}

suite "Array.drop" {
  test "drop n number of items" {
    try {
      result =
        [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8
        ]
        |> Array.drop(2)

      (result == [
        3,
        4,
        5,
        6,
        7,
        8
      ])
    }
  }
}

suite "Array.dropRight" {
  test "drop n number of items from the right" {
    Array.dropRight(2, [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8
    ]) == [
      1,
      2,
      3,
      4,
      5,
      6
    ]
  }

  test "returns array if number of items is negative" {
    Array.dropRight(-2, [
      1,
      2,
      3,
      4
    ]) == [
      1,
      2,
      3,
      4
    ]
  }
}

suite "Array.groupsOf" {
  test "group into items of specified size" {
    try {
      result =
        [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8
        ]
        |> Array.groupsOf(2)

      (result == [
        [
          1,
          2
        ],
        [
          3,
          4
        ],
        [
          5,
          6
        ],
        [
          7,
          8
        ]
      ])
    }
  }
}

suite "Array.groupsOfFromEnd" {
  test "group into items of specified size" {
    try {
      result =
        Array.groupsOfFromEnd(
          2,
          [
            1,
            2,
            3,
            4,
            5,
            6,
            7
          ])

      (result == [
        [1],
        [
          2,
          3
        ],
        [
          4,
          5
        ],
        [
          6,
          7
        ]
      ])
    }
  }
}

suite "Array.delete" {
  test "it removes the item" {
    Array.delete("a", [
      "a",
      "b",
      "c"
    ]) == [
      "b",
      "c"
    ]
  }
}

suite "Array.unshift" {
  test "it pushes a new item at the head of the array." {
    Array.unshift(2, [
      3,
      4
    ]) == [
      2,
      3,
      4
    ]
  }
}

suite "Array.compact" {
  test "it flattens an array of maybes" {
    Array.compact([
      Maybe.just("A"),
      Maybe.nothing()
    ]) == ["A"]
  }
}

suite "Array.move" {
  test "it returns the array as is if from equals to to" {
    Array.move(0, 0, [
      "A",
      "B",
      "C"
    ]) == [
      "A",
      "B",
      "C"
    ]
  }

  test "it returns the array as is if from is negative" {
    Array.move(-1, 0, [
      "A",
      "B",
      "C"
    ]) == [
      "A",
      "B",
      "C"
    ]
  }

  test "it returns the array as is if from is too big" {
    Array.move(10, 0, [
      "A",
      "B",
      "C"
    ]) == [
      "A",
      "B",
      "C"
    ]
  }

  test "it moves the item to the front if to is negative" {
    Array.move(2, -1, [
      "A",
      "B",
      "C"
    ]) == [
      "C",
      "A",
      "B"
    ]
  }

  test "it moves the item to the back if to is too big" {
    Array.move(0, 10, [
      "A",
      "B",
      "C"
    ]) == [
      "B",
      "C",
      "A"
    ]
  }

  test "it moves the item #1" {
    Array.move(1, 0, [
      "A",
      "B",
      "C"
    ]) == [
      "B",
      "A",
      "C"
    ]
  }

  test "it moves the item #2" {
    Array.move(0, 2, [
      "A",
      "B",
      "C",
      "D",
      "E"
    ]) == [
      "B",
      "C",
      "A",
      "D",
      "E"
    ]
  }

  test "it moves the item #2" {
    Array.move(2, 0, [
      "A",
      "B",
      "C",
      "D",
      "E"
    ]) == [
      "C",
      "A",
      "B",
      "D",
      "E"
    ]
  }
}

suite "Array.insertAt" {
  test "it inserts item at front if the position below zero" {
    Array.insertAt("a", -10, [
      "b",
      "c"
    ]) == [
      "a",
      "b",
      "c"
    ]
  }

  test "it inserts item at front if the position zero" {
    Array.insertAt("a", 0, [
      "b",
      "c"
    ]) == [
      "a",
      "b",
      "c"
    ]
  }

  test "it inserts item at the given position" {
    Array.insertAt("a", 1, [
      "b",
      "c"
    ]) == [
      "b",
      "a",
      "c"
    ]
  }

  test "it inserts item at the given position2" {
    Array.insertAt("a", 2, [
      "b",
      "c"
    ]) == [
      "b",
      "c",
      "a"
    ]
  }

  test "it inserts item at back if the position is greater then " \
  "the length" {
    Array.insertAt("a", 10, [
      "b",
      "c"
    ]) == [
      "b",
      "c",
      "a"
    ]
  }
}

suite "Array.deleteAt" {
  test "it deletes the item at the given index" {
    Array.deleteAt(0, [
      "a",
      "b",
      "c"
    ]) == [
      "b",
      "c"
    ]
  }

  test "it returns array if the index is negative" {
    Array.deleteAt(-1, [
      "a",
      "b",
      "c"
    ]) == [
      "a",
      "b",
      "c"
    ]
  }

  test "it returns array if the index is bigger then length" {
    Array.deleteAt(10, [
      "a",
      "b",
      "c"
    ]) == [
      "a",
      "b",
      "c"
    ]
  }
}

suite "Array.swap" {
  test "it swaps items" {
    Array.swap(0, 1, [
      "a",
      "b"
    ]) == [
      "b",
      "a"
    ]
  }

  test "it returns array if index is negative #1" {
    Array.swap(-1, 1, [
      "a",
      "b"
    ]) == [
      "a",
      "b"
    ]
  }

  test "it returns array if index is negative #2" {
    Array.swap(0, -1, [
      "a",
      "b"
    ]) == [
      "a",
      "b"
    ]
  }

  test "it returns array if index is bigger then the length #1" {
    Array.swap(2, 0, [
      "a",
      "b"
    ]) == [
      "a",
      "b"
    ]
  }

  test "it returns array if index is bigger then the length #2" {
    Array.swap(0, 2, [
      "a",
      "b"
    ]) == [
      "a",
      "b"
    ]
  }
}

suite "Array.updateAt" {
  test "it updates the item at the given index" {
    Array.updateAt(
      2,
      (number : Number) : Number { number + 2 },
      [
        0,
        1,
        2
      ]) == [
      0,
      1,
      4
    ]
  }
}

suite "Array.setAt" {
  test "it sets the item at the given index" {
    Array.setAt(2, 5, [
      1,
      2,
      3
    ]) == [
      1,
      2,
      5
    ]
  }
}

suite "Array.indexOf" {
  test "it returns the index of the item" {
    Array.indexOf("a", [
      "a",
      "b",
      "c"
    ]) == 0
  }

  test "it returns the index of an enum" {
    Array.indexOf(Http.Error::Aborted, [Http.Error::Aborted]) == 0
  }
}

suite "Array.indexBy" {
  test "it returns the index of the item" {
    Array.indexBy(
      "a",
      (item : String) : String { item },
      [
        "a",
        "b",
        "c"
      ]) == 0
  }
}
