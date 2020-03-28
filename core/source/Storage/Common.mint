/* Represents the possible failures when dealing with the `Storage` API. */
enum Storage.Error {
  /* The storage API is disabled. */
  SecurityError

  /* The storage is full (over the qouta, usually 5MB). */
  QuotaExceeded

  /* The key in the storage does not exists. */
  NotFound

  /* The reason for the faliure is unknown. */
  Unknown
}

/* Common implementation of the storage api. */
module Storage.Common {
  /* Sets the given key to the given value in the given storage. */
  fun set (storage : Storage, key : String, value : String) : Result(Storage.Error, Void) {
    `
    (() => {
      try {
        #{storage}.setItem(#{key}, #{value})
        return #{Result::Ok(void)}
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result::Err(Storage.Error::SecurityError)}
          case 'QUOTA_EXCEEDED_ERR':
            return #{Result::Err(Storage.Error::QuotaExceeded)}
          case 'QuotaExceededError':
            return #{Result::Err(Storage.Error::QuotaExceeded)}
          case 'NS_ERROR_DOM_QUOTA_REACHED':
            return #{Result::Err(Storage.Error::QuotaExceeded)}
          default:
            return #{Result::Err(Storage.Error::Unknown)}
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
        let value = #{storage}.getItem(#{key})

        if (typeof value === "string") {
          return #{Result::Ok(`value`)}
        } else {
          return #{Result::Err(Storage.Error::NotFound)}
        }
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result::Err(Storage.Error::SecurityError)}
          default:
            return #{Result::Err(Storage.Error::Unknown)}
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
        #{storage}.removeItem(#{key})
        return #{Result::Ok(void)}
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result::Err(Storage.Error::SecurityError)}
          default:
            return #{Result::Err(Storage.Error::Unknown)}
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
        #{storage}.clear()
        return #{Result::Ok(void)}
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result::Err(Storage.Error::SecurityError)}
          default:
            return #{Result::Err(Storage.Error::Unknown)}
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
        return #{Result::Ok(`#{storage}.length`)}
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result::Err(Storage.Error::SecurityError)}
          default:
            return #{Result::Err(Storage.Error::Unknown)}
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
        return #{Result::Ok(`Object.keys(#{storage}).sort()`)}
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result::Err(Storage.Error::SecurityError)}
          default:
            return #{Result::Err(Storage.Error::Unknown)}
        }
      }
    })()
    `
  }
}
