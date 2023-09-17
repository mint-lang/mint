module Locale {
  /* Sets the current locale. */
  fun set (locale : String) : Bool {
    `_L.set(#{locale})`
  }

  /* Returns the current locale. */
  fun get : Maybe(String) {
    `
    (() => {
      if (_L.locale) {
        return #{Maybe::Just(`_L.locale`)}
      } else {
        return #{Maybe::Nothing}
      }
    })()
    `
  }
}
