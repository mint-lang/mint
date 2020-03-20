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
  /* Handles keypress events. */
  fun actions (event : Html.Event) : Void {
    `
     (() => {
      /* Start the combo with the pressed key */
      const combo = [#{event.keyCode}]

      /* Add 17 if control is pressed. */
      if (#{event.ctrlKey} && #{event.keyCode} != 17) { combo.push(17) }

      /* Add 16 if shift is pressed. */
      if (#{event.shiftKey} && #{event.keyCode} != 16) { combo.push(16) }

      #{subscriptions}.forEach((subscription) => {
        subscription.shortcuts.forEach((data) => {
          if (_compare(data.shortcut.sort(), combo.sort()) && data.condition()) {
            if (!document.querySelector("*:focus") || data.bypassFocused) {
              event.preventDefault()
              event.stopPropagation()
              data.action()
            }
          }
        })
      })
    })()
    `
  }

  fun attach : Void {
    `
    (() => {
      const actions = this._actions || (this._actions = #{actions}.bind(this))
      window.addEventListener("keydown", actions, true)
    })()
    `
  }

  fun detach : Void {
    `
    (() => {
      window.removeEventListener("keydown", this._actions, true)
    })()
    `
  }
}
