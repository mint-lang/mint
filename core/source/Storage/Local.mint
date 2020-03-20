/* Functions for the `localStorage` API. */
module Storage.Local {
  /* Sets the given key to the given value. */
  fun set (key : String, value : String) : Result(Storage.Error, Void) {
    Storage.Common.set(`localStorage`, key, value)
  }

  /* Gets the value of given key. */
  fun get (key : String) : Result(Storage.Error, String) {
    Storage.Common.get(`localStorage`, key)
  }

  /* Removes the value with the given key. */
  fun remove (key : String) : Result(Storage.Error, Void) {
    Storage.Common.remove(`localStorage`, key)
  }

  /* Clears the local storage. */
  fun clear : Result(Storage.Error, Void) {
    Storage.Common.clear(`localStorage`)
  }

  /* Returns the number of items in the local storage. */
  fun size : Result(Storage.Error, Number) {
    Storage.Common.size(`localStorage`)
  }

  /* Returns the keys in the local storage. */
  fun keys : Result(Storage.Error, Array(String)) {
    Storage.Common.keys(`localStorage`)
  }
}
