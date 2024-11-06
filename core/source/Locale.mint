/*
This module provides functions to get and change the locale of the
application.
*/
module Locale {
  /*
  Sets the current locale.

    Locale.set("en")
  */
  fun set (locale : String) : Bool {
    `#{%setLocale%}(#{locale})`
  }

  /*
  Returns the current locale.

    Locale.get() == Maybe.Just("en")
  */
  fun get : Maybe(String) {
    `
    (() => {
      if (#{%locale%}) {
        return #{Maybe.Just(`#{%locale%}`)}
      } else {
        return #{Maybe.Nothing}
      }
    })()
    `
  }
}
