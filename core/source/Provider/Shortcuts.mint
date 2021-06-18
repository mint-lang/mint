/*
Represents a shortcut:

- **action** - the function to execute when the shortcut is pressed
- **condition** - the function that evaluates if the action should be called
- **shortcut** - the array of **keyCodes** that needs to be matched.
- **bypassFocused** - whether or not trigger the action if something is in focus
*/
record Provider.Shortcuts.Shortcut {
  action : Function(Promise(Never, Void)),
  condition : Function(Bool),
  shortcut : Array(Number),
  bypassFocused : Bool
}

/* Record for `Provider.Shortcuts`. */
record Provider.Shortcuts.Subscription {
  shortcuts : Array(Provider.Shortcuts.Shortcut)
}

/* This provider allows components to subscribe to global shortcuts. */
provider Provider.Shortcuts : Provider.Shortcuts.Subscription {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe::Nothing

  /* Handles keypress events. */
  fun handle (event : Html.Event) : Array(Array(Promise(Never, Void))) {
    try {
      control =
        if (event.ctrlKey && event.keyCode != 17) {
          Maybe::Just(17)
        } else {
          Maybe::Nothing
        }

      shift =
        if (event.shiftKey && event.keyCode != 16) {
          Maybe::Just(16)
        } else {
          Maybe::Nothing
        }

      combo =
        [Maybe::Just(event.keyCode), control, shift]
        |> Array.compact()
        |> Array.sortBy((item : Number) { item })

      focused =
        `document.querySelector("*:focus")`

      for (subscription of subscriptions) {
        for (item of subscription.shortcuts) {
          try {
            Html.Event.stopPropagation(event)
            Html.Event.preventDefault(event)
            item.action()
          }
        } when {
          try {
            sorted =
              item.shortcut
              |> Array.sortBy((item : Number) : Number { item })

            (sorted == combo && item.condition()) && (!focused || item.bypassFocused)
          }
        }
      }
    }
  }

  /* Updates the provider. */
  fun update : Promise(Never, Void) {
    if (Array.isEmpty(subscriptions)) {
      try {
        Maybe.map((unsubscribe : Function(Void)) { unsubscribe() }, listener)
        next { listener = Maybe::Nothing }
      }
    } else {
      case (listener) {
        Maybe::Nothing =>
          next { listener = Maybe::Just(Window.addEventListener("keydown", true, handle)) }

        => next { }
      }
    }
  }
}
