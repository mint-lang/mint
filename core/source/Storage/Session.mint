/* Functions for the `sessionStorage` API. */
module Storage.Session {
  /*
  Clears the session storage.

    Storage.Session.clear()
  */
  fun clear : Result(Storage.Error, Void) {
    Storage.Common.clear(`sessionStorage`)
  }

  /*
  Delete the value with the given key.

    Storage.Session.delete("key")
  */
  fun delete (key : String) : Result(Storage.Error, Void) {
    Storage.Common.delete(`sessionStorage`, key)
  }

  /*
  Gets the value of given key.

    Storage.Session.get("key")
  */
  fun get (key : String) : Result(Storage.Error, String) {
    Storage.Common.get(`sessionStorage`, key)
  }

  /*
  Returns the keys in the session storage.

    Storage.Session.keys() == []
  */
  fun keys : Result(Storage.Error, Array(String)) {
    Storage.Common.keys(`sessionStorage`)
  }

  /*
  Sets the given key to the given value.

    Storage.Session.set("key", "value")
  */
  fun set (key : String, value : String) : Result(Storage.Error, Void) {
    Storage.Common.set(`sessionStorage`, key, value)
  }

  /*
  Returns the number of items in the session storage.

    Storage.Session.size() == 0
  */
  fun size : Result(Storage.Error, Number) {
    Storage.Common.size(`sessionStorage`)
  }
}
