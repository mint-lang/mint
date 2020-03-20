/* Represents an HTML event. */
record Html.Event {
  bubbles : Bool,
  cancelable : Bool,
  currentTarget : Dom.Element,
  defaultPrevented : Bool,
  eventPhase : Number,
  isTrusted : Bool,
  target : Dom.Element,
  timeStamp : Number,
  type : String,
  data : String,
  altKey : Bool,
  charCode : Number,
  ctrlKey : Bool,
  key : String,
  keyCode : Number,
  locale : String,
  location : Number,
  metaKey : Bool,
  repeat : Bool,
  shiftKey : Bool,
  which : Number,
  button : Number,
  buttons : Number,
  clientX : Number,
  clientY : Number,
  pageX : Number,
  pageY : Number,
  screenX : Number,
  screenY : Number,
  detail : Number,
  deltaMode : Number,
  deltaX : Number,
  deltaY : Number,
  deltaZ : Number,
  animationName : String,
  pseudoElement : String,
  propertyName : String,
  elapsedTime : Number,
  event : Html.NativeEvent
}

/* Utilit functions for `Html.Event` */
module Html.Event {
  fun fromEvent (event : Html.NativeEvent) : Html.Event {
    {
      bubbles = `#{event}.bubbles`,
      cancelable = `#{event}.cancelable`,
      currentTarget = `#{event}.currentTarget`,
      defaultPrevented = `#{event}.defaultPrevented`,
      eventPhase = `#{event}.eventPhase`,
      isTrusted = `#{event}.isTrusted`,
      target = `#{event}.target`,
      timeStamp = `#{event}.timeStamp`,
      type = `#{event}.type`,
      data = `#{event}.data`,
      altKey = `#{event}.altKey`,
      charCode = `#{event}.charCode`,
      ctrlKey = `#{event}.ctrlKey`,
      key = `#{event}.key`,
      keyCode = `#{event}.keyCode`,
      locale = `#{event}.locale`,
      location = `#{event}.location`,
      metaKey = `#{event}.metaKey`,
      repeat = `#{event}.repeat`,
      shiftKey = `#{event}.shiftKey`,
      which = `#{event}.which`,
      button = `#{event}.button`,
      buttons = `#{event}.buttons`,
      clientX = `#{event}.clientX`,
      clientY = `#{event}.clientY`,
      pageX = `#{event}.pageX`,
      pageY = `#{event}.pageY`,
      screenX = `#{event}.screenX`,
      screenY = `#{event}.screenY`,
      detail = `#{event}.detail`,
      deltaMode = `#{event}.deltaMode`,
      deltaX = `#{event}.deltaX`,
      deltaY = `#{event}.deltaY`,
      deltaZ = `#{event}.deltaZ`,
      animationName = `#{event}.animationName`,
      pseudoElement = `#{event}.pseudoElement`,
      propertyName = `#{event}.propertyName`,
      elapsedTime = `#{event}.elapsedTime`,
      event = event
    }
  }

  /*
  Stops the propagation of the given event.

    try {
      Html.Event.stopPropagation(event)
      doSomethingElse()
    }
  */
  fun stopPropagation (event : Html.Event) : Void {
    `#{event.event}.stopPropagation()`
  }

  /*
  Returns whether or not the events propagation is stopped or not.

    Html.Event.isPropagationStopped(event)
  */
  fun isPropagationStopped (event : Html.Event) : Bool {
    `#{event.event}.isPropagationStopped()`
  }

  /*
  Prevents the default action of the event from happening.

    try {
      Html.Event.preventDefault(event)
      doSomethingElse()
    }
  */
  fun preventDefault (event : Html.Event) : Void {
    `#{event.event}.preventDefault()`
  }
}
