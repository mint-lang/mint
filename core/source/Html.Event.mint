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
  elapsedTime : Number
}

/* Utilit functions for `Html.Event` */
module Html.Event {
  /*
  Stops the propagation of the given event.

    do {
      Html.Event.stopPropagation(event)
      doSomethingElse()
    }
  */
  fun stopPropagation (event : Html.Event) : Void {
    `event.stopPropagation()`
  }

  /*
  Returns whether or not the events propagation is stopped or not.

    Html.Event.isPropagationStopped(event)
  */
  fun isPropagationStopped (event : Html.Event) : Bool {
    `event.isPropagationStopped()`
  }

  /*
  Prevents the default action of the event from happening.

    do {
      Html.Event.preventDefault(event)
      doSomethingElse()
    }
  */
  fun preventDefault (event : Html.Event) : Void {
    `event.preventDefault()`
  }
}
