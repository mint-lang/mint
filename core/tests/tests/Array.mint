suite "Array equality" {
  test "simple values" {
    ["a", "b"] == ["a", "b"]
  }

  test "different values" {
    ["b".just] != ["a".just]
  }
}

suite "Array.first" {
  test "returns nothing for empty array" {
    [].first().isNothing()
  }

  test "returns just(a) for non-empty array" {
    ["a", "b"].first().isJust()
  }

  test "returns the first item of non-empty array" {
    ["a", "b"].first().withDefault("") == "a"
  }
}

suite "Array.firstWithDefault" {
  test "returns the first item if exists" {
    ["a", "b", "c"].firstWithDefault("") == "a"
  }

  test "returns the default value if the item does not exists" {
    [].firstWithDefault("") == ""
  }
}

suite "Array.last" {
  test "returns nothing for empty array" {
    [].last().isNothing()
  }

  test "returns Maybe::Just(a) for non-empty array" {
    ["a", "b"].last().isJust()
  }

  test "returns the last item of non-empty array" {
    ["a", "b"].last().withDefault("") == "b"
  }
}

suite "Array.lastWithDefault" {
  test "returns the first item if exists" {
    ["a", "b", "c"].lastWithDefault("") == "c"
  }

  test "returns the default value if the item does not exists" {
    [].lastWithDefault("") == ""
  }
}

suite "Array.size" {
  test "returns 0 for empty array" {
    [].size() == 0
  }

  test "returns 1 for an array with 1 item" {
    [""].size() == 1
  }

  test "returns 5 for an array with 5 items" {
    ["", "", "", "", ""].size() == 5
  }
}

suite "Array.push" {
  test "appends item" {
    [].push("a").size() == 1
  }

  test "appends item to the end" {
    ["x", "y", "z"].push("a").last().withDefault("") == "a"
  }
}

suite "Array.reverse" {
  test "reverses an array" {
    ["x", "y"].reverse().first().withDefault("") == "y"
  }
}

suite "Array.map" {
  test "maps over the items of the array" {
    ["A", "B"].map(String.toLowerCase).first().withDefault("") == "a"
  }
}

suite "Array.mapWithIndex" {
  test "maps over the items and their indexes of the array" {
    (["A", "B"]
      .mapWithIndex((item : String, index : Number) { "#{item}#{index}" })
      .first()
      .withDefault("")) == "A0"
  }
}

suite "Array.select" {
  test "keeps items that match that predicate" {
    [1, 2, 3, 4, 5].select(Number.isOdd).size() == 3
  }
}

suite "Array.reject" {
  test "keeps items that match that does not predicate" {
    [1, 2, 3, 4, 5].reject(Number.isOdd).size() == 2
  }
}

suite "Array.find" {
  test "finds the first item that matches the predicate" {
    ([1, 2, 3, 4, 5, 6]
      .find((number : Number) { number == 3 })
      .withDefault(0)) == 3
  }

  test "finds item if it equals to false" {
    ([true, false]
      .find((item : Bool) { item == false })
      .withDefault(true)) == false
  }
}

suite "Array.any" {
  test "returns true if finds any item that matches the predicate" {
    [1, 2, 3, 4, 5, 6].any((number : Number) : Bool { number == 3 })
  }

  test "returns false if no item matches the predicate" {
    ([1, 2, 3, 4, 5, 6].any((number : Number) : Bool { number == 9 })) == false
  }
}

suite "Array.sort" {
  test "sorts the array based on predicate function" {
    [3, 2, 1].sort((a : Number, b : Number) : Number { a - b }) == [1, 2, 3]
  }
}

suite "Array.sortBy" {
  test "sorts the array based on predicate function" {
    [3, 2, 1].sortBy((a : Number) : Number { a }) == [1, 2, 3]
  }
}

suite "Array.slice" {
  test "returns empty array for empty array" {
    [].slice(0, 0).isEmpty()
  }

  test "returns part of the array" {
    [1, 2, 3, 4, 5].slice(1, 3) == [2, 3]
  }
}

suite "Array.isEmpty" {
  test "returns true for empty array" {
    [].isEmpty()
  }

  test "returns false for non-empty array" {
    ["a"].isEmpty() == false
  }
}

suite "Array.intersperse" {
  test "inserts the separator between items" {
    ["a", "b", "c", "d"].intersperse("|").join("") == "a|b|c|d"
  }
}

suite "Array.concat" {
  test "concatenates multiple arrays together" {
    [["a"], ["b"]].concat() == ["a", "b"]
  }
}

suite "Array.append" {
  test "appends the second array before the first" {
    ["b"].append(["a"]) == ["a", "b"]
  }
}

suite "Array.contains" {
  test "returns true if the array contains the exact item" {
    ["a", "b"].contains("a")
  }

  test "returns false if the it does not contain the exact item" {
    ["a", "b"].contains("c") == false
  }
}

suite "Array.range" {
  test "returns an array of numbers for the given range" {
    (Array.range(0, 10).map(Number.toString).join("")) == "012345678910"
  }
}

suite "Array.sample" {
  test "it returns nothing if the array is empty" {
    [].sample() == Maybe.nothing()
  }

  test "it returns the only item if the array" {
    [0].sample() == Maybe.just(0)
  }

  test "it returns an item from the array" {
    [0, 1].sample().isJust()
  }
}

suite "Array.at" {
  test "it returns nothing at 0 if the array is empty" {
    [].at(0) == Maybe.nothing()
  }

  test "it returns nothing index is over the arrays length" {
    [].at(1) == Maybe.nothing()
  }

  test "it returns item at index #1" {
    [0].at(0) == Maybe.just(0)
  }

  test "it returns item at index #2" {
    [1, 2, 3].at(2) == Maybe.just(3)
  }
}

suite "Array.reduce" {
  test "it reduces an array to a single value" {
    [1, 2, 3].reduce(0, (memo : Number, item : Number) { memo + item }) == 6
  }
}

suite "Array.reduceRight" {
  test "it reduces an array to a single value from the right" {
    [1, 2, 3].reduceRight(0, (memo : Number, item : Number) { memo + item }) == 6
  }
}

suite "Array.flatMap" {
  test "maps over a nested array and flattens" {
    [[3, 1], [2, 0], [5]]
      .flatMap((n : Array(Number)) { [n.max().withDefault(0)] }) == [3, 2, 5]
  }
}

suite "Array.take" {
  test "take n number of items" {
    [1, 2, 3, 4, 5, 6, 7, 8].take(2) == [1, 2]
  }
}

suite "Array.drop" {
  test "drop n number of items" {
    [1, 2, 3, 4, 5, 6, 7, 8].drop(2) == [3, 4, 5, 6, 7, 8]
  }
}

suite "Array.dropRight" {
  test "drop n number of items from the right" {
    [1, 2, 3, 4, 5, 6, 7, 8].dropRight(2) == [1, 2, 3, 4, 5, 6]
  }

  test "returns array if number of items is negative" {
    [1, 2, 3, 4].dropRight(-2) == [1, 2, 3, 4]
  }
}

suite "Array.groupsOf" {
  test "group into items of specified size" {
    [1, 2, 3, 4, 5, 6, 7, 8].groupsOf(2) == [[1, 2], [3, 4], [5, 6], [7, 8]]
  }
}

suite "Array.groupsOfFromEnd" {
  test "group into items of specified size" {
    [1, 2, 3, 4, 5, 6, 7].groupsOfFromEnd(2) == [[1], [2, 3], [4, 5], [6, 7]]
  }
}

suite "Array.delete" {
  test "it removes the item" {
    ["a", "b", "c"].delete("a") == ["b", "c"]
  }
}

suite "Array.unshift" {
  test "it pushes a new item at the head of the array." {
    [3, 4].unshift(2) == [2, 3, 4]
  }
}

suite "Array.compact" {
  test "it flattens an array of maybes" {
    [Maybe.just("A"), Maybe.nothing()].compact() == ["A"]
  }
}

suite "Array.move" {
  test "it returns the array as is if from equals to to" {
    ["A", "B", "C"].move(0, 0) == ["A", "B", "C"]
  }

  test "it returns the array as is if from is negative" {
    ["A", "B", "C"].move(-1, 0) == ["A", "B", "C"]
  }

  test "it returns the array as is if from is too big" {
    ["A", "B", "C"].move(10, 0) == ["A", "B", "C"]
  }

  test "it moves the item to the front if to is negative" {
    ["A", "B", "C"].move(2, -1) == ["C", "A", "B"]
  }

  test "it moves the item to the back if to is too big" {
    ["A", "B", "C"].move(0, 10) == ["B", "C", "A"]
  }

  test "it moves the item #1" {
    ["A", "B", "C"].move(1, 0) == ["B", "A", "C"]
  }

  test "it moves the item #2" {
    ["A", "B", "C", "D", "E"].move(0, 2) == ["B", "C", "A", "D", "E"]
  }

  test "it moves the item #2" {
    ["A", "B", "C", "D", "E"].move(2, 0) == ["C", "A", "B", "D", "E"]
  }
}

suite "Array.insertAt" {
  test "it inserts item at front if the position below zero" {
    ["b", "c"].insertAt("a", -10) == ["a", "b", "c"]
  }

  test "it inserts item at front if the position zero" {
    ["b", "c"].insertAt("a", 0) == ["a", "b", "c"]
  }

  test "it inserts item at the given position" {
    ["b", "c"].insertAt("a", 1) == ["b", "a", "c"]
  }

  test "it inserts item at the given position2" {
    ["b", "c"].insertAt("a", 2) == ["b", "c", "a"]
  }

  test "it inserts item at back if the position is greater then " \
  "the length" {
    ["b", "c"].insertAt("a", 10) == ["b", "c", "a"]
  }
}

suite "Array.deleteAt" {
  test "it deletes the item at the given index" {
    ["a", "b", "c"].deleteAt(0) == ["b", "c"]
  }

  test "it returns array if the index is negative" {
    ["a", "b", "c"].deleteAt(-1) == ["a", "b", "c"]
  }

  test "it returns array if the index is bigger then length" {
    ["a", "b", "c"].deleteAt(10) == ["a", "b", "c"]
  }
}

suite "Array.swap" {
  test "it swaps items" {
    ["a", "b"].swap(0, 1) == ["b", "a"]
  }

  test "it returns array if index is negative #1" {
    ["a", "b"].swap(-1, 1) == ["a", "b"]
  }

  test "it returns array if index is negative #2" {
    ["a", "b"].swap(0, -1) == ["a", "b"]
  }

  test "it returns array if index is bigger then the length #1" {
    ["a", "b"].swap(2, 0) == ["a", "b"]
  }

  test "it returns array if index is bigger then the length #2" {
    ["a", "b"].swap(0, 2) == ["a", "b"]
  }
}

suite "Array.updateAt" {
  test "it updates the item at the given index" {
    [0, 1, 2].updateAt(2, (number : Number) { number + 2 }) == [0, 1, 4]
  }
}

suite "Array.setAt" {
  test "it sets the item at the given index" {
    [1, 2, 3].setAt(2, 5) == [1, 2, 5]
  }
}

suite "Array.indexOf" {
  test "it returns the index of the item" {
    ["a", "b", "c"].indexOf("a") == 0
  }

  test "it returns the index of an enum" {
    [Http.Error::Aborted].indexOf(Http.Error::Aborted) == 0
  }
}

suite "Array.indexBy" {
  test "it returns the index of the item" {
    ["a", "b", "c"].indexBy("a", (item : String) { item }) == 0
  }
}

suite "Array.sumBy" {
  test "it sums up the array by using the function" {
    [1, 2, 3].sumBy((value : Number) { value }) == 6
  }
}

suite "Array.sum" {
  test "it sums up the array" {
    [1, 2, 3].sum() == 6
  }
}

suite "Array.max" {
  test "it returns the largest number" {
    [1, 2, 3].max() == Maybe.just(3)
  }

  test "it returns nothing" {
    [].max() == Maybe.nothing()
  }
}

suite "Array.min" {
  test "it returns smallest number" {
    [1, 2, 3].min() == Maybe.just(1)
  }

  test "it returns nothing" {
    [].min() == Maybe.nothing()
  }
}

suite "Array.uniq" {
  test "removes duplicated from the array" {
    [1, 2, 3, 1, 2, 3].uniq() == [1, 2, 3]
  }
}
