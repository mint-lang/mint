/* Functions for the Set data structure which represents a set of unique values. */
module Set {
  /* Returns an empty set. */
  fun empty : Set(a) {
    `new Set()`
  }

  /*
  Converts the Set to an Array.

    (Set.empty()
    |> Set.add("value")
    |> Set.toArray()) == ["value"]
  */
  fun toArray (set : Set(a)) : Array(a) {
    `Array.from(set)`
  }

  /*
  Converts an Array to a Set.

    (Set.empty()
    |> Set.add("value")) == Set.fromArray(["value"])
  */
  fun fromArray (array : Array(a)) : Set(a) {
    `new Set(array)`
  }

  /*
  Returns whether or not the given set has the given value.

    (Set.empty()
    |> Set.add(Maybe.just("value"))
    |> Set.has(Maybe.just("value"))) == true
  */
  fun has (value : a, set : Set(a)) : Bool {
    `
    (() => {
      for (let item of set) {
        if (_compare(item, value)) {
          return true
        }
      }

      return false
    })()
    `
  }

  /*
  Adds the given value to the set.

    (Set.empty()
    |> Set.add("value")) == Set.fromArray(["value"])
  */
  fun add (value : a, set : Set(a)) : Set(a) {
    `
    (() => {
      const newSet = new Set()

      set.forEach((item) => {
        newSet.add(item)
      })

      newSet.add(value)

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
  fun delete (value : a, set : Set(a)) : Set(a) {
    `
    (() => {
      const newSet = new Set()

      set.forEach((item) => {
        newSet.add(item)
      })

      newSet.delete(value)

      return newSet
    })()
    `
  }

  /*
  Maps over the items of the set to return a new set.

    (Set.fromArray([0])
    |> Set.map(Number.toString)) == Set.fromArray(["0"])
  */
  fun map (method : Function(a, b), set : Set(a)) : Set(b) {
    `
    (() => {
      const newSet = new Set()

      set.forEach((item) => {
        newSet.add(method(item))
      })

      return newSet
    })()
    `
  }
}
