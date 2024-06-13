/*
This module provides functions to work with the [SessionStorage Web API].

[SessionStorage Web API]: https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage
*/
module Storage.Session {
  /*
  Clears the session storage.

    Storage.Session.clear()
  */
  fun clear : Result(Storage.Error, Void) {
    Storage.Common.clear(`sessionStorage`)
  }

  /*
  Deletes the value with the key from the session storage.

    Storage.Session.delete("key")
  */
  fun delete (key : String) : Result(Storage.Error, Void) {
    Storage.Common.delete(`sessionStorage`, key)
  }

  /*
  Gets the value of the key in the session storage.

    Storage.Session.set("key", "value")
    Storage.Session.get("key") // "value"
  */
  fun get (key : String) : Result(Storage.Error, String) {
    Storage.Common.get(`sessionStorage`, key)
  }

  /*
  Returns all the keys in the session storage.

    Storage.Session.set("key", "value")
    Storage.Session.keys() == ["key"]
  */
  fun keys : Result(Storage.Error, Array(String)) {
    Storage.Common.keys(`sessionStorage`)
  }

  /*
  Sets the key to the value in the session storage.

    Storage.Session.set("key", "value")
  */
  fun set (key : String, value : String) : Result(Storage.Error, Void) {
    Storage.Common.set(`sessionStorage`, key, value)
  }

  /*
  Returns the number of items in the session storage.

    Storage.Session.set("key", "value")
    Storage.Session.size() == 1
  */
  fun size : Result(Storage.Error, Number) {
    Storage.Common.size(`sessionStorage`)
  }
}
