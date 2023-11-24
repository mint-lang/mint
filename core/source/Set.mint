/* Functions for the Set data structure which represents a set of unique values. */
module Set {
  /*
  Adds the given value to the set.

    (Set.empty()
    |> Set.add("value")) == Set.fromArray(["value"])
  */
  fun add (set : Set(item), value : item) : Set(item) {
    `
    (() => {
      if (#{has(set, value)}) { return #{set} }

      const newSet = Array.from(#{set})
      newSet.push(#{value})

      return newSet
    })()
    `
  }

  /*
  Deletes the given value from the set.

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

  /* Returns an empty set. */
  fun empty : Set(item) {
    `[]`
  }

  /*
  Converts an Array to a Set.

    (Set.empty()
    |> Set.add("value")) == Set.fromArray(["value"])
  */
  fun fromArray (array : Array(item)) : Set(item) {
    `#{Array.uniq(array)}`
  }

  /*
  Returns whether or not the given set has the given value.

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
  Returns the size of a set

    Set.size(Set.fromArray([0,1,2])) == 3
  */
  fun size (set : Set(item)) : Number {
    `#{set}.length`
  }

  /*
  Converts the Set to an Array.

    (Set.empty()
    |> Set.add("value")
    |> Set.toArray()) == ["value"]
  */
  fun toArray (set : Set(item)) : Array(item) {
    `#{set}`
  }
}
