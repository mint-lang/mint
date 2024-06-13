/*
This module provides functions to work with the [LocalStorage Web API].

[LocalStorage Web API]: https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage
*/
module Storage.Local {
  /*
  Clears the local storage.

    Storage.Local.clear()
  */
  fun clear : Result(Storage.Error, Void) {
    Storage.Common.clear(`localStorage`)
  }

  /*
  Deletes the value with the key from the local storage.

    Storage.Local.delete("key")
  */
  fun delete (key : String) : Result(Storage.Error, Void) {
    Storage.Common.delete(`localStorage`, key)
  }

  /*
  Gets the value of the key in the local storage.

    Storage.Local.set("key", "value")
    Storage.Local.get("key") // "value"
  */
  fun get (key : String) : Result(Storage.Error, String) {
    Storage.Common.get(`localStorage`, key)
  }

  /*
  Returns all the keys in the local storage.

    Storage.Local.set("key", "value")
    Storage.Local.keys() == ["key"]
  */
  fun keys : Result(Storage.Error, Array(String)) {
    Storage.Common.keys(`localStorage`)
  }

  /*
  Sets the key to the value in the local storage.

    Storage.Local.set("key", "value")
  */
  fun set (key : String, value : String) : Result(Storage.Error, Void) {
    Storage.Common.set(`localStorage`, key, value)
  }

  /*
  Returns the number of items in the local storage.

    Storage.Local.set("key", "value")
    Storage.Local.size() == 1
  */
  fun size : Result(Storage.Error, Number) {
    Storage.Common.size(`localStorage`)
  }
}
