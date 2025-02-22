/* This module provides functions for the `Set` type. */
module Set {
  /*
  Adds the value to the set.

    Set.add(Set.empty(), "value") == Set.fromArray(["value"])
  */
  fun add (set : Set(item), value : item) : Set(item) {
    if has(set, value) {
      set
    } else {
      `
      (() => {
        const newSet = Array.from(#{set})
        newSet.push(#{value})

        return newSet
      })()
      `
    }
  }

  /*
  Deletes the value from the set.

    (Set.empty()
    |> Set.add("value")
    |> Set.delete("value")) == Set.empty()
  */
  fun delete (set : Set(item), value : item) : Set(item) {
    `
    (() => {
      const newSet = []

      #{set}.forEach((item) => {
        if (#{%compare%}(item, #{value})) { return }
        newSet.push(item)
      })

      return newSet
    })()
    `
  }

  /*
  Returns an empty set.

    Set.empty()
  */
  fun empty : Set(item) {
    `[]`
  }

  /*
  Converts an `Array(a)` to a `Set(a)`, duplicates are removed.

    Set.add(Set.empty(), "value") == Set.fromArray(["value"])
  */
  fun fromArray (array : Array(item)) : Set(item) {
    `#{Array.uniq(array)}`
  }

  /*
  Returns whether or not the set has the value.

    (Set.empty()
    |> Set.add(Maybe.just("value"))
    |> Set.has(Maybe.just("value"))) == true
  */
  fun has (set : Set(item), value : item) : Bool {
    `
    (() => {
      for (let item of #{set}) {
        if (#{%compare%}(item, #{value})) {
          return true
        }
      }

      return false
    })()
    `
  }

  /*
  Maps over the items of the set to return a new set.

    (Set.fromArray([0])
    |> Set.map(Number.toString)) == Set.fromArray(["0"])
  */
  fun map (set : Set(item), method : Function(item, b)) : Set(b) {
    `
    (() => {
      const newSet = []

      #{set}.forEach((item) => {
        newSet.push(#{method}(item))
      })

      return newSet
    })()
    `
  }

  /*
  Returns the size of a set.

    Set.size(Set.fromArray([0, 1, 2])) == 3
  */
  fun size (set : Set(item)) : Number {
    `#{set}.length`
  }

  /*
  Converts the `Set(a)` to an `Array(a)`.

    (Set.empty()
    |> Set.add("value")
    |> Set.toArray()) == ["value"]
  */
  fun toArray (set : Set(item)) : Array(item) {
    `#{set}`
  }

  /*
  Applies the function against an accumulator and each element in the set (in
    insertion order, according to the set's underlying array representation) to
    reduce it to a single value.

    ([1, 2, 3]
      |> Set.fromArray
      |> Set.reduce(0, (memo : Number, item : Number) : Number { memo + item })) == 6
  */
  fun reduce (
    set : Set(item),
    initial : memo,
    function : Function(memo, item, memo)
  ) {
    `#{set}.reduce(#{function}, #{initial})`
  }

  /*
  Returns a set containing all items in the two input sets.

    let left =
      [1, 2, 3]
      |> Set.fromArray

    let right =
      [3, 4, 5]
      |> Set.fromArray

    (Set.union(left, right)
    |> Set.toArray
    |> Array.sort((a : Number, b : Number) { a - b })) == [1, 2, 3, 4, 5]
  */
  fun union (left : Set(item), right : Set(item)) : Set(item) {
    reduce(left, right, Set.add)
  }

  /*
  Returns a set containing all those elements shared by the two input sets.

    let left =
      [1, 2, 3, 4]
      |> Set.fromArray

    let right =
      [3, 4, 5, 6]
      |> Set.fromArray

    Set.union(left, right) == Set.fromArray([3, 4])
  */
  fun intersection (left : Set(item), right : Set(item)) : Set(item) {
    reduce(left, Set.empty(),
      (memo : Set(item), value : item) {
        if Set.has(right, value) {
          Set.add(memo, value)
        } else {
          memo
        }
      })
  }

  /*
  Returns a set containing elements from the first input set which are not in
    the second input set.

    let left =
      [1, 2, 3, 4]
      |> Set.fromArray

    let right =
      [3, 4, 5, 6]
      |> Set.fromArray

    Set.difference(left, right) == Set.fromArray([1, 2])
  */
  fun difference (left : Set(item), right : Set(item)) : Set(item) {
    reduce(left, Set.empty(),
      (memo : Set(item), value : item) {
        if Set.has(right, value) {
          memo
        } else {
          Set.add(memo, value)
        }
      })
  }

  /*
  Returns true if the input sets contain no elements in common.

    let left =
      [1, 2, 3, 4]
      |> Set.fromArray

    let right =
      [0, 5, -1, 6]
      |> Set.fromArray

    Set.isDisjoint(left, right) == true
  */
  fun isDisjoint (left : Set(item), right : Set(item)) : Bool {
    reduce(left, true,
      (memo : Bool, value : item) { memo && !Set.has(right, value) })
  }

  /*
  Returns true if the first input set contains every element in the second input
  set.

    let inner =
      [1, 2, 3, 4]
      |> Set.fromArray

    let outer =
      [3, 4, 5, 6, 1, 2]
      |> Set.fromArray

    Set.isSuperset(outer, inner) == true
  */
  fun isSuperset (outer : Set(item), inner : Set(item)) : Bool {
    reduce(inner, true,
      (memo : Bool, value : item) { memo && Set.has(outer, value) })
  }
}
