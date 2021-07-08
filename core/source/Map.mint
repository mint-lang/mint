/*
Functions for the Map data structure for mapping keys to values.

Implementation whise we are using an array of tuples where the first item is
the key, where the second item is the value.
*/
module Map {
  /*
  Removes the item with the key.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.delete("a")) == Map.empty()
  */
  fun delete (keyToDelete : key, map : Map(key, value)) : Map(key, value) {
    Map.fromArray(
      for (key, value of map) {
        {key, value}
      } when {
        key != keyToDelete
      })
  }

  /*
  Removes all keys which match the value.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 1)
    |> Map.deleteValues(1)) == Map.empty()
  */
  fun deleteValues (valueToDelete : value, map : Map(key, value)) : Map(key, value) {
    Map.fromArray(
      for (key, value of map) {
        {key, value}
      } when {
        value != valueToDelete
      })
  }

  /* Returns an empty map. */
  fun empty : Map(x, z) {
    `[]`
  }

  /*
  Returns the map as an array of key/value tuples.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.entries()) == [{"a", 1}, {"b", 2}]
  */
  fun entries (map : Map(a, b)) : Array(Tuple(a, b)) {
    `#{map}`
  }

  /*
  Returns the first key which is matched by the function.

    (Map.empty()
    |> Map.set("a", 0)
    |> Map.set("b", 1)
    |> Map.findKeyBy((value : Number) : Bool {
      value == 1
    })) == Maybe.just("b")
  */
  fun findKeyBy (
    function : Function(value, Bool),
    map : Map(key, value)
  ) : Maybe(key) {
    Array.first(
      for (key, value of map) {
        key
      } when {
        function(value)
      })
  }

  /*
  Converts an array of key/value tuples into a Map.

     (Map.empty()
     |> Map.set("a", 1)
     |> Map.set("b", 2)
     ) == Map.fromArray([{"a", 1}, {"b", 2}])
  */
  fun fromArray (array : Array(Tuple(a, b))) : Map(a, b) {
    `#{array}`
  }

  /*
  Gets the value of the key.

    Map.empty()
    |> Map.set("key", "value")
    |> Map.get("key") == Maybe.just("value")
  */
  fun get (search : key, map : Map(key, value)) : Maybe(value) {
    Array.first(
      for (key, value of map) {
        value
      } when {
        key == search
      })
  }

  /*
  Gets the value of the key using the value as fallback.

    (Map.empty()
    |> Map.set("key", "value")
    |> Map.getWithDefault("key", "fallback")) == "value"

    (Map.empty()
    |> Map.getWithDefault("key", "fallback")) == "fallback"
  */
  fun getWithDefault (key : key, value : value, map : Map(key, value)) : value {
    get(key, map) or value
  }

  /*
  Returns whether or not the map has the key.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.has("a")) == true
  */
  fun has (search : key, map : Map(key, value)) : Bool {
    Array.first(
      for (key, value of map) {
        true
      } when {
        key == search
      }) or false
  }

  /*
  Returns whether or not the map is empty.

    (Map.empty()
    |> Map.isEmpty()) == true

    (Map.empty()
    |> Map.set("a", "b")
    |> Map.isEmpty()) == false
  */
  fun isEmpty (map : Map(key, value)) : Bool {
    `#{map}.length === 0`
  }

  /*
  Returns the keys of a map as an array.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.values()) == ["a", "b"]
  */
  fun keys (map : Map(key, value)) : Array(key) {
    for (key, value of map) {
      key
    }
  }

  /*
  Maps over the keys/values pairs with the function.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.map((key : String, value : Number) : Number { value * 2 })
    |> Map.values()) == [2,4]
  */
  fun map (
    function : Function(key, value, result),
    map : Map(key, value)
  ) : Map(key, result) {
    Map.fromArray(
      for (key, value of map) {
        ({key, function(key, value)})
      })
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
    |> Map.get("a")) == Maybe::Just("y")
  */
  fun merge (map1 : Map(key, value), map2 : Map(key, value)) : Map(key, value) {
    Map.reduce(
      map1,
      (memo : Map(key, value), key : key, value : value) {
        Map.set(key, value, memo)
      },
      map2)
  }

  /*
  Reduces the map from the left using the accumulator function.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.reduce(
      0,
      (memo : Number, key : String, value : Number) : Number {
        memo + value
      })) == 3
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
  Assigns the value to the key in the map.

    Map.empty()
    |> Map.set("key", "value")
  */
  fun set (key : key, value : value, map : Map(key, value)) : Map(key, value) {
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
  Returns the number of items in the map.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.size()) == 1
  */
  fun size (map : Map(key, value)) : Number {
    `#{map}.length`
  }

  /*
  Sorts the map using the function.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.sortBy((key : String, value : Number) : Number {
      value - 100
    })
    |> Map.values()) == ["b", "a"]
  */
  fun sortBy (
    method : Function(key, value, result),
    map : Map(key, value)
  ) : Map(key, value) {
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
  Returns the values of a map as an array.

    (Map.empty()
    |> Map.set("a", 1)
    |> Map.set("b", 2)
    |> Map.values()) == [1, 2]
  */
  fun values (map : Map(key, value)) : Array(value) {
    for (key, value of map) {
      value
    }
  }
}
