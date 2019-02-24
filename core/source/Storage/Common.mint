/* Represents the possible failures when dealing with the `Storage` API. */
enum Storage.Error {
  /* The storage API is disabled. */
  SecurityError

  /* The storage is full (over the qouta, usually 5MB). */
  QuotaExceeded

  /* The key in the storage does not exists. */
  NotFound

  /* The reason for the faliure is unkown. */
  Unkown
}

/* Common implementation of the storage api. */
module Storage.Common {
  /* Sets the given key to the given value in the given storage. */
  fun set (storage : Storage, key : String, value : String) : Result(Storage.Error, Void) {
    `
    (() => {
      try {
        storage.setItem(key, value)
        return new Ok(null)
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return new Err(#{Storage.Error::SecurityError})
          case 'QUOTA_EXCEEDED_ERR':
            return new Err(#{Storage.Error::QuotaExceeded})
          case 'QuotaExceededError':
            return new Err(#{Storage.Error::QuotaExceeded})
          case 'NS_ERROR_DOM_QUOTA_REACHED':
            return new Err(#{Storage.Error::QuotaExceeded})
          default:
            return new Err(#{Storage.Error::Unkown})
        }
      }
    })()
    `
  }

  /* Gets the value of given key in the given storage. */
  fun get (storage : Storage, key : String) : Result(Storage.Error, String) {
    `
    (() => {
      try {
        let value = storage.getItem(key)

        if (typeof value === "string") {
          return new Ok(value)
        } else {
          return new Err(#{Storage.Error::NotFound})
        }
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return new Err(#{Storage.Error::SecurityError})
          default:
            return new Err(#{Storage.Error::Unkown})
        }
      }
    })()
    `
  }

  /* Removes the value with the given key from the given storage. */
  fun remove (storage : Storage, key : String) : Result(Storage.Error, Void) {
    `
    (() => {
      try {
        storage.removeItem(key)
        return new Ok(null)
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return new Err(#{Storage.Error::SecurityError})
          default:
            return new Err(#{Storage.Error::Unkown})
        }
      }
    })()
    `
  }

  /* Clears the given storage. */
  fun clear (storage : Storage) : Result(Storage.Error, Void) {
    `
    (() => {
      try {
        storage.clear()
        return new Ok(null)
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return new Err(#{Storage.Error::SecurityError})
          default:
            return new Err(#{Storage.Error::Unkown})
        }
      }
    })()
    `
  }

  /* Returns the number of items in the storage. */
  fun size (storage : Storage) : Result(Storage.Error, Number) {
    `
    (() => {
      try {
        return new Ok(storage.length)
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return new Err(#{Storage.Error::SecurityError})
          default:
            return new Err(#{Storage.Error::Unkown})
        }
      }
    })()
    `
  }

  /* Returns the keys in the given storage. */
  fun keys (storage : Storage) : Result(Storage.Error, Array(String)) {
    `
    (() => {
      try {
        return new Ok(Object.keys(storage).sort())
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return new Err(#{Storage.Error::SecurityError})
          default:
            return new Err(#{Storage.Error::Unkown})
        }
      }
    })()
    `
  }
}
