/* Module for functions to manipulate immutable arrays. */
module Array {
  /*
  Returns `true` if any item in the array matches the predicate function
  `false` otherwise.

    Array.any([1, 2, 3, 4], (number : Number) : Bool { number % 2 == 0 }) == true
    Array.any([1, 3], (number : Number) : Bool { number % 2 == 0 }) == false
  */
  fun any (array : Array(item), function : Function(item, Bool)) : Bool {
    Array.find(array, function) != Maybe.Nothing
  }

  /*
  Merges two arrays together into a new one.

    Array.append([1, 1, 2] [3, 5, 8]) == [1, 1, 2, 3, 5, 8]
  */
  fun append (array1 : Array(item), array2 : Array(item)) : Array(item) {
    `[...#{array1}, ...#{array2}]`
  }

  /*
  Returns the element at the given index as a `Maybe(item)`.

    Array.at([0], 0) == Maybe.Just(0)
    Array.at([0], 1) == Maybe.Nothing()
  */
  fun at (array : Array(item), index : Number) : Maybe(item) {
    array[index]
  }

  /*
  Flattens an `Array(Maybe(item))` into an `Array(item)`, by unwrapping the
  items and skipping all elements of `Maybe.Nothing`.

    Array.compact([Maybe.Just("A"), Maybe.Nothing()]) == ["A"]
  */
  fun compact (array : Array(Maybe(item))) : Array(item) {
    Array.reduce(
      array,
      [],
      (memo : Array(item), item : Maybe(item)) : Array(item) {
        case item {
          Just(value) => Array.push(memo, value)
          Nothing => memo
        }
      })
  }

  /*
  Concatenate multiple arrays into a single array.

    Array.concat([[1,2],[3],[4,5]]) == [1,2,3,4,5]
  */
  fun concat (arrays : Array(Array(item))) : Array(item) {
    reduce(arrays, [], append)
  }

  /*
  Checks whether or not the given element exists in the array.

    Array.contains(["a", "b", "c"], "a") == true
    Array.contains(["x", "y", "z"], "a") == false
  */
  fun contains (array : Array(item), other : item) : Bool {
    `
    (() => {
      for (let item of #{array}) {
        if (#{%compare%}(#{other}, item)) {
          return true
        }
      }

      return false
    })()
    `
  }

  /*
  Deletes every occurrence of the element from the array.

    Array.delete(["a", "b", "c"], "a") == ["b", "c"]
  */
  fun delete (array : Array(item), what : item) : Array(item) {
    reject(array, (item : item) { item == what })
  }

  /*
  Deletes the item of an array at the specified index.

    Array.deleteAt(["a", "b", "c"], 1) == ["a", "c"]
  */
  fun deleteAt (array : Array(item), index : Number) : Array(item) {
    `
    (() => {
      if (#{index} < 0 || #{index} >= #{array}.length) { return #{array} }
      const result = [...#{array}]
      result.splice(#{index}, 1)
      return result
    })()
    `
  }

  /*
  Drop the specified number of items from the end of the array.

    Array.dropEnd([1, 2, 3, 4], 2) == [1, 2]
  */
  fun dropEnd (array : Array(item), number : Number) : Array(item) {
    `
    (() => {
      if (#{number} < 0) { return #{array} }
      return #{array}.slice(0, -#{number})
    })()
    `
  }

  /*
  Drop the specified number of items from the start of the array.

    Array.dropStart([1, 2, 3, 4], 2) == [3, 4]
  */
  fun dropStart (array : Array(item), number : Number) : Array(item) {
    `#{array}.slice(#{number})`
  }

  /*
  Finds the first element in the array that matches the predicate function.

    Array.find([1, 2, 3, 4], (number : Number) { number % 2 == 0 }) == Maybe.Just(2)
  */
  fun find (array : Array(item), function : Function(item, Bool)) : Maybe(item) {
    for item of array {
      item
    } when {
      function(item)
    }[0]
  }

  /*
  Finds the first element in the array that matches the predicate function and
  returns the second item in the resulting tuple.

    Array.findByAndMap(
      [1, 2, 3, 4],
      (number : Number) : (Bool, value) { {number % 2 == 0, "Two"} }
    ) == Maybe.Just("Two")
  */
  fun findByAndMap (
    array : Array(item),
    function : Function(item, Tuple(Bool, result))
  ) : Maybe(b) {
    `
    (() => {
      for (let item of #{array}) {
        const [found, value] = #{function}(item)

        if (found) {
          return #{Maybe.Just(`value`)}
        }
      }

      return #{Maybe.Nothing}
    })()
    `
  }

  /*
  Returns the first element of the array as `Maybe.Just(item)` or
  `Maybe.Nothing`.

    Array.first(["a", "x"]) == Maybe.Just("a")
    Array.first([]) == Maybe.Nothing
  */
  fun first (array : Array(item)) : Maybe(item) {
    array[0]
  }

  /*
  Returns the first element of the array or the default value.

    Array.firstWithDefault(["b", "x"], "a") == "b"
    Array.firstWithDefault([], "a") == "a"
  */
  fun firstWithDefault (array : Array(item), item : item) : item {
    array[0] or item
  }

  /*
  Map over a nested array and then flatten.

    Array.flatMap(
      [[1,2],[1,5]],
      (item : Array(Number) : Array(Maybe(Number)) {
        [Maybe.withDefault(Array.max(item), 0)]
      }) == [2,5]
  */
  fun flatMap (
    array : Array(Array(item)),
    function : Function(Array(item), Array(result))
  ) : Array(result) {
    concat(map(array, function))
  }

  /*
  Group an array into sub groups of specified length (all items are included so
  the last group maybe shorter if after grouping there is a remainder)

    Array.groupsOf([1,2,3,4,5,6,7], 2) == [[1,2],[3,4],[5,6],[7]]
  */
  fun groupsOf (array : Array(item), size : Number) : Array(Array(item)) {
    `
    (() => {
      const groups = Math.ceil(#{array}.length/#{size})
      const result = []

      let lowerLimit = 0

      for (var $0 = 0; $0 < groups; $0++) {
        lowerLimit = $0 * #{size};
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

    Array.groupsOfFromEnd([1,2,3,4,5,6,7], 2) == [[1],[2,3],[4,5],[6,7]]
  */
  fun groupsOfFromEnd (array : Array(item), size : Number) : Array(Array(item)) {
    `
    (() => {
      const groups = Math.ceil(#{array}.length / #{size})
      const result = []

      let lowerLimit = 0

      #{array} =
        [...#{array}].reverse()

      for (var $0 = 0; $0 < groups; $0++) {
        lowerLimit = $0 * #{size};
        result.unshift(#{array}.slice(lowerLimit, lowerLimit +  #{size}).reverse())
      }

      return result;
    })()
    `
  }

  /*
  Returns the index of the item in the array which matches the value
  using the function to generate the compared value.

    Array.indexBy(["a","b","c"], "a", (item : String) : String { item }) == 0
  */
  fun indexBy (
    array : Array(item),
    value : result,
    method : Function(item, result)
  ) : Number {
    `
    (() => {
      for (let index = 0; index < #{array}.length; index++) {
        if (#{%compare%}(#{value}, #{method}(#{array}[index]))) {
          return index
        }
      }

      return -1
    })()
    `
  }

  /*
  Returns the index of the specified item in the array.

    Array.indexOf(["a","b","c"], "a") == 0
  */
  fun indexOf (array : Array(item), search : item) : Maybe(Number) {
    for item, index of array {
      index
    } when {
      item == search
    }[0]
  }

  /*
  Inserts the item into the specified position of the array, pushing items
  toward the end of the array. If the length is negative the item will be
  inserted at the start of the array.

    Array.insertAt(["b","c"], "a", 0) == ["a","b","c"]
  */
  fun insertAt (array : Array(item), item : item, position : Number) : Array(item) {
    `
    (() => {
      const result = [...#{array}]

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
  Inserts the element between the elements of the array.

    Array.intersperse(["x", "y", "z"], "a") == ["x", "a", "y", "a", "z"]
  */
  fun intersperse (array : Array(item), item : item) : Array(item) {
    `#{array}.reduce((array, value)=>[...array, value, #{item}], []).slice(0,-1)`
  }

  /*
  Returns whether or not the array is empty.

    Array.isEmpty(["a", "b"]) == false
    Array.isEmpty([]) == true
  */
  fun isEmpty (array : Array(item)) : Bool {
    size(array) == 0
  }

  /*
  Returns the last element of the array as `Maybe.Just(a)` or `Maybe.Nothing`.

    Array.last(["x", "a"]) == Maybe.Just("a")
    Array.last([]) == Maybe.Nothing
  */
  fun last (array : Array(item)) : Maybe(item) {
    `
    (() => {
      let last = #{array}[#{array}.length - 1];

      if (last !== undefined) {
        return #{Maybe.Just(`last`)}
      } else {
        return #{Maybe.Nothing}
      }
    })()
    `
  }

  /*
  Returns the last element of the array or the default value.

    Array.lastWithDefault(["x", "b"], "a") == "b"
    Array.lastWithDefault([], "a") == "a"
  */
  fun lastWithDefault (array : Array(item), item : item) : item {
    Maybe.withDefault(last(array), item)
  }

  /*
  Creates a new array with the results of calling a provided function on every
  element in the array.

    Array.map([1, 2, 3], (number : Number) : Number { number + 1 }) == [2, 3, 4]
  */
  fun map (array : Array(item), method : Function(item, result)) : Array(result) {
    for item of array {
      method(item)
    }
  }

  /*
  Creates a new array with the results of calling a provided function on every
  element in the array while providing the index of the element.

    Array.mapWithIndex(
      [1, 2, 3],
      (number : Number, index : Number) : Number { number + index }
    ) == [2, 4, 6]
  */
  fun mapWithIndex (
    array : Array(item),
    method : Function(item, Number, result)
  ) : Array(result) {
    for item, index of array {
      method(item, index)
    }
  }

  /*
  Returns the maximum value of an array of numbers. It's a maybe because the
  array might not have items in it.

    Array.max([0, 1, 2, 3, 4]) == Maybe.Just(4)
    Array.max([]) == Maybe.Nothing
  */
  fun max (array : Array(Number)) : Maybe(Number) {
    if Array.size(array) > 0 {
      Maybe.Just(`Math.max(...#{array})`)
    } else {
      Maybe.Nothing
    }
  }

  /*
  Returns the minimum value of an array of numbers. It's a maybe because the
  array might not have items in it.

    Array.min([0, 1, 2, 3, 4]) == Maybe.Just(0)
    Array.min([]) == Maybe.Nothing
  */
  fun min (array : Array(Number)) : Maybe(Number) {
    if Array.size(array) > 0 {
      Maybe.Just(`Math.min(...#{array})`)
    } else {
      Maybe.Nothing
    }
  }

  /*
  Moves an item at the index `from` to a new index `to`.

  The array is returned as is if:
  * `from` and `to` are the same
  * a negative number is supplied to `from`
  * a number is supplied to `from` which is grater the the length of the array

    Array.move(["A", "B", "C"], -1, 1) == ["A", "B", "C"]
    Array.move(["A", "B", "C"], 10, 1) == ["A", "B", "C"]
    Array.move(["A", "B", "C"], 0, 0) == ["A", "B", "C"]

  If a negative number is supplied to `to` then, the item is moved to the
  first position.

    Array.move(["A", "B", "C"], 2, -1) == ["C", "A", "B"]

  If a number is supplied to `to` which is grater the the length of the array,
  then the item is moved to the last position.

    Array.move(["A", "B", "C"], 0, 10) == ["B", "C", "A"]
  */
  fun move (array : Array(item), from : Number, to : Number) : Array(item) {
    `
    (() => {
      const result = [...#{array}]

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
  Push an element to the end of an array.

    Array.push([1, 2, 3], 4) == [1, 2, 3, 4]
    Array.push([], "a") == ["a"]
  */
  fun push (array : Array(item), item : item) : Array(item) {
    `[...#{array}, #{item}]`
  }

  /*
  Creates an array of numbers starting from the first argument and
  ending in the last.

    Array.range(0, 5) == [0, 1, 2, 3, 4, 5]
  */
  fun range (from : Number, to : Number) : Array(Number) {
    `Array.from({ length: (#{to} + 1) - #{from} }).map((v, $0) => $0 + #{from})`
  }

  /*
  Applies the function against an accumulator and each element in the array
  (from start to end) to reduce it to a single value.

    Array.reduce(
      [1, 2, 3],
      0,
      (memo : Number, item : Number) : Number { memo + item }) == 6
  */
  fun reduce (
    array : Array(item),
    initial : memo,
    function : Function(memo, item, memo)
  ) : memo {
    `#{array}.reduce(#{function}, #{initial})`
  }

  /*
  Applies the function against an accumulator and each element in the array
  (from end to start) to reduce it to a single value.

    Array.reduceEnd(
      [1,2,3,4,5],
      0,
      (acc : Number, n : Number) : Number { acc + n}) == 15
  */
  fun reduceEnd (
    array : Array(item),
    initial : memo,
    function : Function(memo, item, memo)
  ) : memo {
    `#{array}.reduceRight(#{function}, #{initial})`
  }

  /*
  Returns all elements that do not match the predicate function.

    Array.reject([1, 2, 3, 4], (number : Number) : Bool { number % 2 == 0 }) == [1, 3]
  */
  fun reject (array : Array(item), function : Function(item, Bool)) : Array(item) {
    `#{array}.filter((item) => !#{function}(item))`
  }

  /*
  Returns a new array where the elements are reversed. The first array element
  becomes the last, and the last array element becomes the first.

    Array.reverse([1, 2, 3]) == [3, 2, 1]
  */
  fun reverse (array : Array(item)) : Array(item) {
    `[...#{array}].reverse()`
  }

  /*
  Returns a new array where the elements are reversed if the condition is true.

    Array.reverseIf([1, 2, 3], false) == [1, 2, 3]
    Array.reverseIf([1, 2, 3], true) == [3, 2, 1]
  */
  fun reverseIf (array : Array(item), condition : Bool) : Array(item) {
    if condition {
      Array.reverse(array)
    } else {
      array
    }
  }

  /*
  Returns a random element from the array.

    Array.sample(["a"]) == Maybe.Just("a")
    Array.sample() == Maybe.Nothing()
  */
  fun sample (array : Array(item)) : Maybe(item) {
    `
    (() => {
      if (#{array}.length) {
        const item = #{array}[Math.floor(Math.random() * #{array}.length)]

        return #{Maybe.Just(`item`)}
      } else {
        return #{Maybe.Nothing}
      }
    })()
    `
  }

  /*
  Returns all elements that match the predicate function.

    Array.select([1, 2, 3, 4], (number : Number) : Bool { number % 2 == 0 }) == [2, 4]
  */
  fun select (array : Array(item), function : Function(item, Bool)) : Array(item) {
    `#{array}.filter(#{function})`
  }

  /*
  Sets the item at index to the item of the array, if the specified index is
  not found in the array it returns the array unchanged.

    Array.setAt([1,2,3], 2, 5) == [1,2,5]
  */
  fun setAt (array : Array(item), index : Number, item : item) : Array(item) {
    `
    (() => {
      if (#{index} < 0 || #{index} >= #{array}.length) { return #{array} }
      const result = [...#{array}]
      result[#{index}] = #{item}
      return result
    })()
    `
  }

  /*
  Returns the size of the array.

    Array.size([1, 2, 3]) == 3
    Array.size([]) == 0
  */
  fun size (array : Array(item)) : Number {
    `#{array}.length`
  }

  /*
  Returns a copy of a portion of an array (end not included).

    Array.slice(["ant", "bison", "camel", "duck", "elephant"], 2, 4) == ["camel", "duck"]
  */
  fun slice (array : Array(item), begin : Number, end : Number) : Array(item) {
    `#{array}.slice(#{begin}, #{end})`
  }

  /*
  Returns a new sorted array using the sorting function `compareFunction(a, b)`.
  Items are sorted using a number:

  * `> 0` - sort b before a
  * `< 0` - sort a before b
  * `0` - keep original order of a and b

    Array.sort([4, 1, 3, 2], (a : Number, b : Number) : Number { a - b }) == [1, 2, 3, 4]
  */
  fun sort (
    array : Array(item),
    function : Function(item, item, Number)
  ) : Array(item) {
    `[...#{array}].sort(#{function})`
  }

  /*
  Returns a new sorted array using the functions return as the base of
  the sorting.

    Array.sortBy([4, 1, 3, 2], (number : Number) : Number { number }) == [1, 2, 3, 4]
  */
  fun sortBy (
    array : Array(item),
    function : Function(item, result)
  ) : Array(item) {
    `
    (() => {
      return #{array}.sort((a, b) => {
        let aVal = #{function}(a)
        let bVal = #{function}(b)

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
  Sums up the array of numbers.

    Array.sum([1, 2, 3]) == 6
  */
  fun sum (array : Array(Number)) : Number {
    Array.reduce(
      array,
      0,
      (memo : Number, item : Number) : Number {
        item + memo
      })
  }

  /*
  Sums up the array using the specified function.

    Array.sumBy([1, 2, 3], (value : Number) : Number { value }) == 6
  */
  fun sumBy (array : Array(item), method : Function(item, Number)) : Number {
    array
    |> Array.map(method)
    |> Array.sum()
  }

  /*
  Swaps the items at the specified indexes of the array. It returns the array
  unchanged if there is no item at any of the specified indexes.

    Array.swap(["a","b"], 0, 1) == ["b", "a"]
  */
  fun swap (array : Array(item), index1 : Number, index2 : Number) : Array(item) {
    `
    (() => {
      if (#{index1} < 0 ||
          #{index2} < 0 ||
          #{index1} >= #{array}.length ||
          #{index2} >= #{array}.length) {
        return #{array}
      }

      const result = [...#{array}]
      const saved = result[#{index1}]
      result[#{index1}] = result[#{index2}]
      result[#{index2}] = saved;
      return result
    })()
    `
  }

  /*
  Takes the specified number of items from the end of the array.

    Array.takeEnd([1, 2, 3, 4], 2) == [3, 4]
  */
  fun takeEnd (array : Array(item), number : Number) : Array(item) {
    `#{array}.slice(-#{number})`
  }

  /*
  Takes the specified number of items from the start of the array.

    Array.takeStart([1, 2, 3, 4], 2) == [1, 2]
  */
  fun takeStart (array : Array(item), number : Number) : Array(item) {
    `#{array}.slice(0, #{number})`
  }

  /*
  Removes duplicate items from the array.

    Array.uniq(["a", "a", "b", "b", "c"] == ["a", "b", "c"]
  */
  fun uniq (array : Array(item)) : Array(item) {
    for item, index of array {
      item
    } when {
      indexOf(array, item) == Maybe.Just(index)
    }
  }

  /*
  Pushes a new item at the head of the array.

    Array.unshift([3, 4], 2) == [2, 3, 4]
  */
  fun unshift (array : Array(item), item : item) : Array(item) {
    `
    (() => {
      const result = [...#{array}]
      result.unshift(#{item})
      return result
    })()
    `
  }

  /*
  Updates the item at the given index of the given array using the given
  function.

    Array.updateAt(
      [0,1,2], 2, (number : Number) : Number {
        number + 2
      }) == [0,1,4]
  */
  fun updateAt (
    array : Array(item),
    index : Number,
    method : Function(item, item)
  ) : Array(item) {
    case array[index] {
      Maybe.Just(item) => setAt(array, index, method(item))
      Maybe.Nothing => array
    }
  }
}
