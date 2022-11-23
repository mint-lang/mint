/* Functions for the `localStorage` API. */
module Storage.Local {
  /*
  Clears the local storage.

    Storage.Local.clear()
  */
  fun clear : Result(Storage.Error, Void) {
    Storage.Common.clear(`localStorage`)
  }

  /*
  Delete the value with the given key.

    Storage.Local.delete("key")
  */
  fun delete (key : String) : Result(Storage.Error, Void) {
    Storage.Common.delete(`localStorage`, key)
  }

  /*
  Gets the value of given key.

    Storage.Local.get("key")
  */
  fun get (key : String) : Result(Storage.Error, String) {
    Storage.Common.get(`localStorage`, key)
  }

  /*
  Returns the keys in the local storage.

    Storage.Local.keys() == []
  */
  fun keys : Result(Storage.Error, Array(String)) {
    Storage.Common.keys(`localStorage`)
  }

  /*
  Sets the given key to the given value.

    Storage.Local.set("key", "value")
  */
  fun set (key : String, value : String) : Result(Storage.Error, Void) {
    Storage.Common.set(`localStorage`, key, value)
  }

  /*
  Returns the number of items in the local storage.

    Storage.Local.size() == 0
  */
  fun size : Result(Storage.Error, Number) {
    Storage.Common.size(`localStorage`)
  }
}
