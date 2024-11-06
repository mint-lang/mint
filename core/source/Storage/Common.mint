/* Represents the possible failures when dealing with the `Storage` API. */
type Storage.Error {
  /* The storage API is disabled. */
  SecurityError

  /* The storage is full (over the quota, usually 5MB). */
  QuotaExceeded

  /* The key in the storage does not exist. */
  NotFound

  /* The reason for the failure is unknown. */
  Unknown
}

/*
This module provides functions to work with the [Storage Web API]. This module
should not be used directly, it is used by `Storage.Local` and `Storage.Session`
modules.

[Storage Web API]: https://developer.mozilla.org/en-US/docs/Web/API/Storage
*/
module Storage.Common {
  /* Clears the storage, removing all key-value pairs. */
  fun clear (storage : Storage) : Result(Storage.Error, Void) {
    `
    (() => {
      try {
        #{storage}.clear()
        return #{Result.Ok(void)}
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result.Err(Storage.Error.SecurityError)}
          default:
            return #{Result.Err(Storage.Error.Unknown)}
        }
      }
    })()
    `
  }

  /* Deletes the value with the key from the storage. */
  fun delete (storage : Storage, key : String) : Result(Storage.Error, Void) {
    `
    (() => {
      try {
        #{storage}.removeItem(#{key})
        return #{Result.Ok(void)}
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result.Err(Storage.Error.SecurityError)}
          default:
            return #{Result.Err(Storage.Error.Unknown)}
        }
      }
    })()
    `
  }

  /* Gets the value of the key in the storage. */
  fun get (storage : Storage, key : String) : Result(Storage.Error, String) {
    `
    (() => {
      try {
        let value = #{storage}.getItem(#{key})

        if (typeof value === "string") {
          return #{Result.Ok(`value`)}
        } else {
          return #{Result.Err(Storage.Error.NotFound)}
        }
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result.Err(Storage.Error.SecurityError)}
          default:
            return #{Result.Err(Storage.Error.Unknown)}
        }
      }
    })()
    `
  }

  /* Returns alll the keys in the storage. */
  fun keys (storage : Storage) : Result(Storage.Error, Array(String)) {
    `
    (() => {
      try {
        return #{Result.Ok(`Object.keys(#{storage}).sort()`)}
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result.Err(Storage.Error.SecurityError)}
          default:
            return #{Result.Err(Storage.Error.Unknown)}
        }
      }
    })()
    `
  }

  /* Sets the key to the value in the storage. */
  fun set (
    storage : Storage,
    key : String,
    value : String
  ) : Result(Storage.Error, Void) {
    `
    (() => {
      try {
        #{storage}.setItem(#{key}, #{value})
        return #{Result.Ok(void)}
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result.Err(Storage.Error.SecurityError)}
          case 'QUOTA_EXCEEDED_ERR':
            return #{Result.Err(Storage.Error.QuotaExceeded)}
          case 'QuotaExceededError':
            return #{Result.Err(Storage.Error.QuotaExceeded)}
          case 'NS_ERROR_DOM_QUOTA_REACHED':
            return #{Result.Err(Storage.Error.QuotaExceeded)}
          default:
            return #{Result.Err(Storage.Error.Unknown)}
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
        return #{Result.Ok(`#{storage}.length`)}
      } catch (error) {
        switch(error.name) {
          case 'SecurityError':
            return #{Result.Err(Storage.Error.SecurityError)}
          default:
            return #{Result.Err(Storage.Error.Unknown)}
        }
      }
    })()
    `
  }
}
