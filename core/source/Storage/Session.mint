/* Functions for the `sessionStorage` API. */
module Storage.Session {
  /* Sets the given key to the given value. */
  set (key : String, value : String) : Result(Storage.Error, Void) {
    Storage.Common.set(`sessionStorage`, key, value)
  }

  /* Gets the value of given key. */
  get (key : String) : Result(Storage.Error, String) {
    Storage.Common.get(`sessionStorage`, key)
  }

  /* Removes the value with the given key. */
  remove (key : String) : Result(Storage.Error, Void) {
    Storage.Common.remove(`sessionStorage`, key)
  }

  /* Clears the session storage. */
  clear : Result(Storage.Error, Void) {
    Storage.Common.clear(`sessionStorage`)
  }

  /* Returns the number of items in the session storage. */
  size : Result(Storage.Error, Number) {
    Storage.Common.size(`sessionStorage`)
  }

  /* Returns the keys in the session storage. */
  keys : Result(Storage.Error, Array(String)) {
    Storage.Common.keys(`sessionStorage`)
  }
}
