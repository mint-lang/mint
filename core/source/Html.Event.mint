/* Represents an HTML event. */
type Html.Event {
  event : Html.NativeEvent,

  clipboardData : Html.DataTransfer,
  dataTransfer : Html.DataTransfer,

  currentTarget : Dom.Element,
  target : Dom.Element,

  defaultPrevented : Bool,
  cancelable : Bool,
  isTrusted : Bool,
  bubbles : Bool,
  repeat : Bool,

  shiftKey : Bool,
  metaKey : Bool,
  ctrlKey : Bool,
  altKey : Bool,

  animationName : String,
  pseudoElement : String,
  propertyName : String,
  locale : String,
  type : String,
  data : String,
  key : String,

  elapsedTime : Number,
  eventPhase : Number,
  timeStamp : Number,
  charCode : Number,
  location : Number,
  keyCode : Number,
  buttons : Number,
  button : Number,
  detail : Number,
  which : Number,

  clientX : Number,
  clientY : Number,
  screenX : Number,
  screenY : Number,
  pageX : Number,
  pageY : Number,

  deltaMode : Number,
  deltaX : Number,
  deltaY : Number,
  deltaZ : Number
}

/* Utility functions for `Html.Event` */
module Html.Event {
  const A = 65
  const ADD = 107
  const ALT = 18
  const B = 66
  const BACKSPACE = 8
  const BACK_SLASH = 220
  const C = 67
  const CAPS_LOCK = 20
  const CLOSE_BRAKET = 221
  const COMMA = 188
  const CTRL = 17
  const D = 68
  const DASH = 189
  const DECIMAL_POINT = 110
  const DELETE = 46
  const DIVIDE = 111
  const DOWN_ARROW = 40
  const E = 69
  const END = 35
  const ENTER = 13
  const EQUAL_SIGN = 187
  const ESCAPE = 27
  const F = 70
  const F1 = 112
  const F10 = 121
  const F11 = 122
  const F12 = 123
  const F2 = 113
  const F3 = 114
  const F4 = 115
  const F5 = 116
  const F6 = 117
  const F7 = 118
  const F8 = 119
  const F9 = 120
  const FORWARD_SLASH = 191
  const G = 71
  const GRAVE_ACCENT = 192
  const H = 72
  const HOME = 36
  const I = 73
  const INSERT = 45
  const J = 74
  const K = 75
  const L = 76
  const LEFT_ARROW = 37
  const LEFT_WINDOW_KEY = 91
  const M = 77
  const MULTIPLY = 106
  const N = 78
  const NUMBER_0 = 48
  const NUMBER_1 = 49
  const NUMBER_2 = 50
  const NUMBER_3 = 51
  const NUMBER_4 = 52
  const NUMBER_5 = 53
  const NUMBER_6 = 54
  const NUMBER_7 = 55
  const NUMBER_8 = 56
  const NUMBER_9 = 57
  const NUMPAD_0 = 96
  const NUMPAD_1 = 97
  const NUMPAD_2 = 98
  const NUMPAD_3 = 99
  const NUMPAD_4 = 100
  const NUMPAD_5 = 101
  const NUMPAD_6 = 102
  const NUMPAD_7 = 103
  const NUMPAD_8 = 104
  const NUMPAD_9 = 105
  const NUM_LOCK = 144
  const O = 79
  const OPEN_BRACKET = 219
  const P = 80
  const PAGE_DOWN = 34
  const PAGE_UP = 33
  const PAUSE_BREAK = 19
  const PERIOD = 190
  const Q = 81
  const R = 82
  const RIGHT_ARROW = 39
  const RIGHT_WINDOW_KEY = 92
  const S = 83
  const SCROLL_LOCK = 145
  const SELECT_KEY = 93
  const SEMI_COLON = 186
  const SHIFT = 16
  const SINGLE_QUOTE = 222
  const SPACE = 32
  const SUBTRACT = 109
  const T = 84
  const TAB = 9
  const U = 85
  const UP_ARROW = 38
  const V = 86
  const W = 87
  const X = 88
  const Y = 89
  const Z = 90

  /*
  Returns whether or not the events propagation is stopped or not.

    Html.Event.isPropagationStopped(event)
  */
  fun isPropagationStopped (event : Html.Event) : Bool {
    `#{event.event}.isPropagationStopped()`
  }

  /*
  Prevents the default action of the event from happening.

    Html.Event.preventDefault(event)
    doSomethingElse()
  */
  fun preventDefault (event : Html.Event) : Void {
    `#{event.event}.preventDefault()`
  }

  /*
  Stops the propagation of the given event.

    Html.Event.stopPropagation(event)
    doSomethingElse()
  */
  fun stopPropagation (event : Html.Event) : Void {
    `#{event.event}.stopPropagation()`
  }
}
