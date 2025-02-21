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
}
