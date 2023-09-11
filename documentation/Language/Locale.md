# Locale

This feature of the language allows specifing localization tokens and values for languages indentified by [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) codes.

```mint
locale en {
  ui: {
    buttons: {
      ok: "OK"
    }
  }
}

locale hu {
  ui: {
    buttons: {
      ok: "Rendben"
    }
  }
}
```

A locale consists of a tree structure where the keys are lowercase identifiers and the values are expressions.

To localize a value you need to use the locale token:

```
:ui.buttons.ok
```

or if it's a function if can be called:

```
locale en {
  ui: {
    buttons: {
      ok: (param1 : String, param2 : String) { 
        "Button #{param1} #{param2}!" 
      }
    }
  }
}

:ui.buttons.ok(param1, param2)
```

To get and set the current locale the `Locale` module can be used:

```
Locale.set("en")
Locale.get() // Maybe::Just("en")
```

Every translation is typed checked:

* all translations of the same key must have the same type
* locale keys must have translations in every defined language

Locales are open like Modules are so they can be defined in multiple places.
