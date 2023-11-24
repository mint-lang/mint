module Locale {
  /* Sets the current locale. */
  fun set (locale : String) : Bool {
    `#{%setLocale%}(#{locale})`
  }

  /* Returns the current locale. */
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
