/* Functions for the Map data structure for mapping keys to values. */
module Map {
  /* Returns an empty map. */
  fun empty : Map(x, z) {
    `[]`
  }

  /*
  Sets the given value to the given key in the map.

    Map.empty()
    |> Map.set("key", "value")
  */
  fun set (key : x, value : z, map : Map(x, z)) : Map(x, z) {
    `
    (() => {
      const result = []
      let set = false

      for (let item of #{map}) {
        if (_compare(item[0], #{key})) {
          set = true
          result.push([#{key}, #{value}])
        } else {
          result.push(item)
        }
      }

      if (!set) {
        result.push([#{key}, #{value}])
      }

      return result
    })()
    `
  }

  /*
  Gets the value for the given key of the given map.

    Map.empty()
    |> Map.set("key", "value")
    |> Map.get("key") == Maybe.just("value")
  */
  fun get (key : x, map : Map(x, z)) : Maybe(z) {
    `
    (() => {
      for (let item of #{map}) {
        if (_compare(item[0], #{key})) {
          return #{Maybe::Just(`item[1]`)}
        }
      }

      return #{Maybe::Nothing}
    })()
    `
  }

  /*
  Gets the value for the given key of the given map using the
  given value as fallback.

    (Map.empty()
    |> Map.set("key", "value")
    |> Map.getWithDefault("key", "fallback")) == "value"

    (Map.empty()
    |> Map.getWithDefault("key", "fallback")) == "fallback"
  */
  fun getWithDefault (key : key, value : value, map : Map(key, value)) : value {
    get(key, map)
    |> Maybe.withDefault(value)
  }

  /*
  Merges two maps together where the second has the precedence.

    a =
      Map.empty()
      |> Map.set("a", "b")

    b =
      Map.empty()
      |> Map.set("a", "y")

    (Map.merge(a, b)
    |> Map.get("a")) == Maybe.just("y")
  */
  fun merge (map1 : Map(x, z), map2 : Map(x, z)) : Map(x, z) {
    map2
    |> Map.reduce(map1, (memo : Map(x, z), key : x, value : z) {
      Map.set(key, value, memo)
    })
  }

  /*
  Reduces the map from the left using the given accumulator function.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.reduce(
      0,
      (memo : Number, key : String, value : Number) : Number { memo + value })) == 3
  */
  fun reduce (
    memo : memo,
    method : Function(memo, key, value, memo),
    map : Map(key, value)
  ) : memo {
    `
    (() => {
      let memo = #{memo}

      for (let item of #{map}) {
        memo = #{method}(memo, item[0], item[1])
      }

      return memo
    })()
    `
  }

  /*
  Returns the first key which is matched by the given function.

    (Map.empty()
    |> Map.set("a", 0)
    |> Map.set("b", 1)
    |> Map.findKey((value : Number) : Bool {
      value == 1
    })) == Maybe.just("b")
  */
  fun findKey (
    method : Function(value, Bool),
    map : Map(key, value)
  ) : Maybe(key) {
    `
    (() => {
      for (let item of #{map}) {
        if (#{method}(item[1])) {
          return #{Maybe::Just(`item[0]`)}
        }
      }

      return #{Maybe::Nothing}
    })()
    `
  }

  /*
  Removes all keys from the map which match the given value.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 1)
    |> Map.deleteValue(1)) == Map.empty()
  */
  fun deleteValue (value : value, map : Map(key, value)) : Map(key, value) {
    `
    (() => {
      const result = []

      for (let item of #{map}) {
        if (!_compare(item[1], #{value})) {
          result.push(item)
        }
      }

      return result
    })()
    `
  }

  /*
  Removes the given key from the map

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.delete("a")) == Map.empty()
  */
  fun delete (key : key, map : Map(key, value)) : Map(key, value) {
    `
    (() => {
      const result = []

      for (let item of #{map}) {
        if (!_compare(item[0], #{key})) {
          result.push(item)
        }
      }

      return result
    })()
    `
  }

  /*
  Returns the values of a map as an array.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.values()) == [1, 2]
  */
  fun values (map : Map(k, a)) : Array(a) {
    `#{map}.map((item) => item[1])`
  }

  /*
  Returns the keys of a map as an array.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.values()) == ["a", "b"]
  */
  fun keys (map : Map(k, a)) : Array(k) {
    `#{map}.map((item) => item[0])`
  }

  /*
  Sorts the map using the given function.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.sortBy((key : String, value : Number) : Number {
      value - 100
    })
    |> Map.values()) == ["b", "a"]
  */
  fun sortBy (method : Function(k, v, b), map : Map(k, v)) : Map(k, v) {
    `
    Array.from(#{map}).sort((a, b) => {
      let aVal = #{method}(a[0], a[1])
      let bVal = #{method}(b[0], b[1])

      if (aVal < bVal) {
        return -1
      }

      if (aVal > bVal) {
        return 1
      }

      return 0
    })
    `
  }

  /*
  Returns whether or not the map is empty.

    (Map.empty()
    |> Map.isEmpty()) == true

    (Map.empty()
    |> Map.set("a", "b")
    |> Map.isEmpty()) == false
  */
  fun isEmpty (map : Map(k, a)) : Bool {
    `#{map}.length === 0`
  }

  /*
  Map over the given map with the given function.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.map((key : String, value : Number) : Number {
      value * 2
    })
    |> Map.values()) == [2,4]
  */
  fun map (method : Function(k, a, b), map : Map(k, a)) : Map(k, b) {
    `
    (() => {
      const result = []

      for (let item of #{map}) {
        result.push([item[0], #{method}(item[0], item[1])])
      }

      return result
    })()
    `
  }

  /*
  Returns whether or not the map has the given key or not.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.has("a")) == true
  */
  fun has (key : k, map : Map(k, a)) : Bool {
    `
    (() => {
      for (let item of #{map}) {
        if (_compare(#{key}, item[0])) {
          return true
        }
      }

      return false
    })()
    `
  }

  /*
  Returns the number of items in the map.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.size()) == 1
  */
  fun size (map : Map(key, value)) : Number {
    `#{map}.length`
  }

  /*
  Returns the array of {key, value} Tuple.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.entries()) == [{"a", 1}, {"b", 2}]
  */
  fun entries (map : Map(a, b)) : Array(Tuple(a, b)) {
    `#{map}`
  }
}
