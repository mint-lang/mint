/* Module for functions to manipulate immutable arrays. */
module Array {
  /*
  Returns the first element of the array as `Maybe.just(a)` or `Maybe.nothing()`.

    Array.first([]) == Maybe.nothing()
    Array.first(["a", "x"]) == Maybe.just("a")
  */
  fun first (array : Array(a)) : Maybe(a) {
    `
    (() => {
      let first = #{array}[0]
      if (first !== undefined) {
        return #{Maybe::Just(`first`)}
      } else {
        return #{Maybe::Nothing}
      }
    })()
    `
  }

  /*
  Returns the first element of the array or the default value.

    Array.firstWithDefault("a", []) == "a"
    Array.firstWithDefault("a", ["b", "x"]) == "b"
  */
  fun firstWithDefault (item : a, array : Array(a)) : a {
    first(array)
    |> Maybe.withDefault(item)
  }

  /*
  Returns the last element of the array as `Just(a)` or `Nothing`.

    Array.last([]) == Maybe.nothing()
    Array.last(["x", "a"]) == Maybe.just("a")
  */
  fun last (array : Array(a)) : Maybe(a) {
    `
    (() => {
      let last = #{array}[#{array}.length - 1]
      if (last !== undefined) {
        return #{Maybe::Just(`last`)}
      } else {
        return #{Maybe::Nothing}
      }
    })()
    `
  }

  /*
  Returns the last element of the array or the default value.

    Array.lastWithDefault("a", []) == "a"
    Array.lastWithDefault("a", ["x", "b"]) == "b"
  */
  fun lastWithDefault (item : a, array : Array(a)) : a {
    last(array)
    |> Maybe.withDefault(item)
  }

  /*
  Returns the size of the array.

    Array.size([]) == 0
    Array.size([1, 2, 3]) == 3
  */
  fun size (array : Array(a)) : Number {
    `#{array}.length`
  }

  /*
  Push an element to the end of an array.

    Array.push("a", []) == ["a"]
    Array.push(4, [1, 2, 3]) == [1, 2, 3, 4]
  */
  fun push (item : a, array : Array(a)) : Array(a) {
    `[...#{array}, #{item}]`
  }

  /*
  Returns a new array where the elements are reversed. The first array element
  becomes the last, and the last array element becomes the first.

    Array.reverse([1, 2, 3]) == [4, 3, 2, 1]
  */
  fun reverse (array : Array(a)) : Array(a) {
    `#{array}.slice().reverse()`
  }

  /*
  Creates a new array with the results of calling a provided
  function on every element in the given array.

    Array.map((number : Number) : Number { number + 1 }, [1, 2, 3]) == [2, 3, 4]
  */
  fun map (func : Function(a, b), array : Array(a)) : Array(b) {
    `#{array}.map(#{func})`
  }

  /*
  Creates a new array with the results of calling a provided
  function on every element in the given array while providing the index of
  the element.

    Array.mapWithIndex(
      (index : Number, number : Number) : Number { number + index }, [1, 2, 3]) == [2, 4, 6]
  */
  fun mapWithIndex (func : Function(a, Number, b), array : Array(a)) : Array(b) {
    `#{array}.map(#{func})`
  }

  /*
  Returns all elements that matches the predicate function.

    Array.select((number : Number) : Bool { number % 2 == 0 }, [1, 2, 3, 4]) == [2, 4]
  */
  fun select (func : Function(a, Bool), array : Array(a)) : Array(a) {
    `#{array}.filter(#{func})`
  }

  /*
  Returns all elements that does not matches the predicate function.

    Array.reject((number : Number) : Bool { number % 2 == 0 }, [1, 2, 3, 4]) == [1, 3]
  */
  fun reject (func : Function(a, Bool), array : Array(a)) : Array(a) {
    `#{array}.filter((item) => !#{func}(item))`
  }

  /*
  Finds the first element in the array that matches the predicate function.

    Array.find((number : Number) : Bool { number % 2 == 0 }, [1, 2, 3, 4]) == Maybe.just(2)
  */
  fun find (func : Function(a, Bool), array : Array(a)) : Maybe(a) {
    `
    (() => {
      let item = #{array}.find(#{func})

      if (item != undefined) {
        return #{Maybe::Just(`item`)}
      } else {
        return #{Maybe::Nothing}
      }
    })()
    `
  }

  /*
  Returns `true` if any item in the array matches the prdicate function
  `false` otherwise.

    Array.any((number : Number) : Bool { number % 2 == 0 }, [1, 2, 3, 4]) == true
    Array.any((number : Number) : Bool { number % 2 == 0 }, [1, 3]) == false
  */
  fun any (func : Function(a, Bool), array : Array(a)) : Bool {
    `!!#{array}.find(#{func})`
  }

  /*
  Returns a new sorted array using the given sorting function.

    Array.sort((a : Number, b : Number) : Number { a - b }, [4, 1, 3, 2]) == [1, 2, 3, 4]
  */
  fun sort (func : Function(a, a, Number), array : Array(a)) : Array(a) {
    `#{array}.slice().sort(#{func})`
  }

  /*
  Returns a new sorted array using the given functions return as the base of
  the sorting.


    Array.sortBy((number : Number) : Number { number }, [4, 1, 3, 2]) == [1, 2, 3, 4]
  */
  fun sortBy (func : Function(a, b), array : Array(a)) : Array(a) {
    `
    (() => {
      return #{array}.sort((a, b) => {
        let aVal = #{func}(a)
        let bVal = #{func}(b)

        if (aVal < bVal) {
          return -1
        }

        if (aVal > bVal) {
          return 1
        }

        return 0
      })
    })()
    `
  }

  /*
  Returns a copy of a portion of an array (end not included).

    Array.slice(2, 4, ["ant", "bison", "camel", "duck", "elephant"]) == ["camel", "duck"]
  */
  fun slice (begin : Number, end : Number, array : Array(a)) : Array(a) {
    `#{array}.slice(#{begin}, #{end})`
  }

  /*
  Returns whether or not the array is empty.

    Array.isEmpty([]) == true
    Array.isEmpty(["a", "b"]) == false
  */
  fun isEmpty (array : Array(a)) : Bool {
    size(array) == 0
  }

  /*
  Inserts the given element between the elements of the given array.

    Array.intersperse("a", ["x", "y", "z"]) == ["x", "a", "y", "a", "z"]
  */
  fun intersperse (item : a, array : Array(a)) : Array(a) {
    `#{array}.reduce((a,v)=>[...a,v,#{item}],[]).slice(0,-1)`
  }

  /*
  Checks whether or not the given element exists in the array.

    Array.contains("a", ["a", "b", "c"]) == true
    Array.contains("a", ["x", "y", "z"]) == false
  */
  fun contains (other : a, array : Array(a)) : Bool {
    `
    (() => {
      for (let item of #{array}) {
        if (_compare(#{other}, item)) {
          return true
        }
      }

      return false
    })()
    `
  }

  /*
  Creates an array of numbers starting from the first agrument and
  ending in the last.

    Array.range(0, 5) == [0, 1, 2, 3, 4, 5]
  */
  fun range (from : Number, to : Number) : Array(Number) {
    `Array.from({ length: (#{to} + 1) - #{from} }).map((v, i) => i + #{from})`
  }

  /*
  Deletes every occurence of the given element from the array.

    Array.delete("a", ["a", "b", "c"]) == ["b", "c"]
  */
  fun delete (what : a, array : Array(a)) : Array(a) {
    reject((item : a) : Bool { item == what }, array)
  }

  /*
  Returns the maximum value of an array of numbers.

    Array.max([0, 1, 2, 3, 4]) == 4
    Array.max([]) == 0
  */
  fun max (array : Array(Number)) : Number {
    `Math.max(...#{array})`
  }

  /*
  Returns an random element from the array.

    Array.sample(["a"]) == Maybe.just("a")
    Array.sample() == Maybe.nothing()
  */
  fun sample (array : Array(a)) : Maybe(a) {
    `
    (() => {
      if (#{array}.length) {
        const item = #{array}[Math.floor(Math.random() * #{array}.length)]

        return #{Maybe::Just(`item`)}
      } else {
        return #{Maybe::Nothing}
      }
    })()
    `
  }

  /*
  Returns the element at the given index.

    Array.at(0, [0]) == Maybe.just(0)
    Array.at(1, [0]) == Maybe.nothing()
  */
  fun at (index : Number, array : Array(a)) : Maybe(a) {
    `_at(#{array}, #{index})`
  }

  /*
  Put two lists together:

    Array.append([1,1,2] [3,5,8]) == [1,1,2,3,5,8]
  */
  fun append (array1 : Array(a), array2 : Array(a)) : Array(a) {
    `[].concat(#{array1}).concat(#{array2})`
  }

  /*
  Concatenate a bunch of arrays into a single array:

    Array.concat([[1,2],[3],[4,5]]) == [1,2,3,4,5]
  */
  fun concat (arrays : Array(Array(a))) : Array(a) {
    reduce([], append, arrays)
  }

  /*
  Applies the given function against an accumulator and each element in the
  array (from left to right) to reduce it to a single value.

    Array.reduce(
      0,
      (memo : Number, item : Number) : Number { memo + item },
      [1, 2, 3]) == 6
  */
  fun reduce (
    initial : b,
    method : Function(b, a, b),
    array : Array(a)
  ) : b {
    `#{array}.reduce(#{method}, #{initial})`
  }

  /*
  Reduce a list from the right.

    [1,2,3,4,5]
    |> Array.reduceRight(0, (acc : Number, n : Number) : Number { acc + n}) == 15
  */
  fun reduceRight (
    initial : b,
    func : Function(b, a, b),
    array : Array(a)
  ) : b {
    `#{array}.reduceRight(#{func}, #{initial})`
  }

  /*
  Map over a nested array and then flatten.

    [[1,2],[1,5]]
    |> Array.flatMap((a : Array(Number) : Array(Number) {
      [Array.max(n)]
    }) == [2,5]
  */
  fun flatMap (func : Function(a, Array(b)), array : Array(a)) : Array(b) {
    concat(map(func, array))
  }

  /*
  Take n number of items from the left.

    Array.take(2, [1,2,3,4]) == [1,2]
  */
  fun take (number : Number, array : Array(a)) : Array(a) {
    `#{array}.slice(0, #{number})`
  }

  /*
  Drop n number of items from the left.

    Array.drop(2, [1,2,3,4]) == [3,4]
  */
  fun drop (number : Number, array : Array(a)) : Array(a) {
    `#{array}.slice(#{number})`
  }

  /*
  Drop n number of items from the right.

    Array.drop(2, [1,2,3,4]) == [1,2]
  */
  fun dropRight (number : Number, array : Array(a)) : Array(a) {
    `
    (() => {
      if (#{number} < 0) { return #{array} }
      return #{array}.slice(0, -#{number})
    })()
    `
  }

  /*
  Group an array into sub groups of specified length (all items are included so
  the last group maybe shorter if after grouping there is a remainder)

    Array.groupsOf(2, [1,2,3,4,5,6,7]) == [[1,2],[3,4],[5,6],[7]]
  */
  fun groupsOf (size : Number, array : Array(a)) : Array(Array(a)) {
    `
    (() => {
      let groups = Math.ceil(#{array}.length/#{size})
      let lowerLimit = 0
      let result = []

      for (var i= 0; i < groups; i++) {
        lowerLimit = i*#{size};
        result.push(#{array}.slice(lowerLimit, lowerLimit + #{size}))
      }

      return result;
    })()
    `
  }

  /*
  Group an array into sub groups of specified length (all items are included so
  the last group maybe shorter if after grouping there is a remainder) starting
  from the end of the array.
7
    Array.groupsOfFromEnd(2, [1,2,3,4,5,6,7]) == [[1],[2,3],[4,5],[6,7]]
  */
  fun groupsOfFromEnd (size : Number, array : Array(a)) : Array(Array(a)) {
    `
    (() => {
      let groups = Math.ceil(#{array}.length / #{size})
      let lowerLimit = 0
      let result = []

      #{array} =
        Array.from(#{array}).reverse()

      for (var i= 0; i < groups; i++) {
        lowerLimit = i* #{size};
        result.unshift(#{array}.slice(lowerLimit, lowerLimit +  #{size}).reverse())
      }

      return result;
    })()
    `
  }

  /*
  Pushes a new item at the head of the array.

    Array.unshift(2, [3,4]) == [2,3,4]
  */
  fun unshift (item : a, array : Array(a)) : Array(a) {
    `
    (() => {
      const result = Array.from(#{array})
      result.unshift(#{item})
      return result
    })()
    `
  }

  /*
  Flattens an `Array(Maybe(a))` into an `Array(a)`, by unwrapping the items
  and skipping nothings.

    Array.compact([Maybe.just("A"), Maybe.nothing()]) == ["A"]
  */
  fun compact (array : Array(Maybe(a))) : Array(a) {
    Array.reduce(
      [],
      (memo : Array(a), item : Maybe(a)) : Array(a) {
        case (item) {
          Maybe::Just value => Array.push(value, memo)
          Maybe::Nothing => memo
        }
      },
      array)
  }

  /*
  Moves an item at the given index (`from`) to a new index (`to`).

  The array is returned as is if:
  * `from` and `to` are the same.
  * a negative number is supplied to `from`
  * a number is supplied to `from` which is grater the the length of the array

    Array.move(-1, 1, ["A", "B", "C"]) == ["A", "B", "C"]
    Array.move(10, 1, ["A", "B", "C"]) == ["A", "B", "C"]
    Array.move(0, 0, ["A", "B", "C"]) == ["A", "B", "C"]

  If a negative number is supplied to `to` then, the item is moved to the
  first position.

    Array.move(2, -1, ["A", "B", "C"]) == ["C", "A", "B"]

  If a number is supplied to `to` which is grater the the length of the array,
  then the item is moved to the last position.

    Array.move(0, 10, ["A", "B", "C"]) == ["B", "C", "A"]
  */
  fun move (from : Number, to : Number, array : Array(a)) : Array(a) {
    `
    (() => {
      const result = Array.from(#{array})

      if (#{from} == #{to} || #{from} < 0 || #{from} >= result.length) {
        return result
      } else if (#{to} < 0) {
        /* If the desired position is lower then zero put at the front. */
        result.unshift(result.splice(#{from}, 1)[0])
      } else if (#{to} >= result.length) {
        /* If the desired position is bigger then length put at the back. */
        result.push(result.splice(#{from}, 1)[0])
      } else {
        /* Else we just move. */
        result.splice(#{to}, 0, result.splice(#{from}, 1)[0])
      }

      return result
    })()
    `
  }

  /*
  Inserts the given item into the given position of the given array.

    Array.insertAt("a", 0, ["b","c"]) == ["a","b","c"]
  */
  fun insertAt (item : a, position : Number, array : Array(a)) : Array(a) {
    `
    (() => {
      const result = Array.from(#{array})

      if (#{position} <= 0) {
        result.unshift(#{item})
      } else {
        result.splice(#{position}, 0, #{item})
      }

      return result
    })()
    `
  }

  /*
  Spaws the items at the given indexes of the given array. It returns the array
  unchanged if there is no item at any of the given indexs.

    Array.swap(0, 1, ["a","b"]) == ["b", "a"]
  */
  fun swap (index1 : Number, index2 : Number, array : Array(a)) : Array(a) {
    `
    (() => {
      if (#{index1} < 0 ||
          #{index2} < 0 ||
          #{index1} >= #{array}.length ||
          #{index2} >= #{array}.length) {
        return #{array}
      }

      const result = Array.from(#{array})
      const saved = result[#{index1}]
      result[#{index1}] = result[#{index2}]
      result[#{index2}] = saved;
      return result
    })()
    `
  }

  /* Deletes the item of an array with the given index. */
  fun deleteAt (index : Number, array : Array(a)) : Array(a) {
    `
    (() => {
      if (#{index} < 0 || #{index} >= #{array}.length) { return #{array} }
      const result = Array.from(#{array})
      result.splice(#{index}, 1)
      return result
    })()
    `
  }

  /*
  Updates the item at the given index of the given array using the given
  function.

    Array.updateAt(
      2, (number : Number) : Number {
        number + 2
      }, [0,1,2]) == [0,1,4]
  */
  fun updateAt (
    index : Number,
    method : Function(a, a),
    array : Array(a)
  ) : Array(a) {
    `
    (() => {
      if (#{array}[#{index}]) {
        return #{setAt(index, method(`#{array}[#{index}]`), array)}
      } else {
        return #{array}
      }
    })()
    `
  }

  /*
  Sets the item at the given index to the given item of the given array.

    Array.setAt(2, 5, [1,2,3]) == [1,2,5]
  */
  fun setAt (index : Number, item : a, array : Array(a)) : Array(a) {
    `
    (() => {
      if (#{index} < 0 || #{index} >= #{array}.length) { return #{array} }
      const result = Array.from(#{array})
      result[#{index}] = #{item}
      return result
    })()
    `
  }

  /*
  Returns the index of the given item in the given array.

    Arrray.indexOf("a", ["a","b","c"]) == 1
  */
  fun indexOf (item : a, array : Array(a)) : Number {
    `
    (() => {
      for (let index = 0; index < #{array}.length; index++) {
        if (_compare(#{item}, #{array}[index])) {
          return index
        }
      }

      return -1
    })()
    `
  }

  /*
  Returns the index of the item in the given array which matches the given value
  using the given function the generate the compared value.

    Array.indexBy("a", (item : String) : String { item }, ["a","b","c"]) == 0
  */
  fun indexBy (value : b, method : Function(a, b), array : Array(a)) : Number {
    `
    (() => {
      for (let index = 0; index < #{array}.length; index++) {
        if (_compare(#{value}, #{method}(#{array}[index]))) {
          return index
        }
      }

      return -1
    })()
    `
  }

  /* Sums up the given array using the given function.

    Array.sumBy((value : Number) : Number { value }, [1, 2, 3]) == 6
  */
  fun sumBy (method : Function(a, Number), array : Array(a)) : Number {
    array
    |> Array.map(method)
    |> Array.sum()
  }

  /* Sums up the given array of numbers.

    Array.sum([1, 2, 3]) == 6
  */
  fun sum (array : Array(Number)) : Number {
    Array.reduce(
      0,
      (memo : Number, item : Number) : Number {
        item + memo
      },
      array)
  }
}
