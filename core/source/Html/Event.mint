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
  offsetX : Number,
  offsetY : Number,
  layerX : Number,
  layerY : Number,
  pageX : Number,
  pageY : Number,

  deltaMode : Number,
  deltaX : Number,
  deltaY : Number,
  deltaZ : Number
}

/* This module provides functions for working with `Html.Event` objects. */
module Html.Event {
  // Constant for the `Right Window Key` key.
  const RIGHT_WINDOW_KEY = 92

  // Constant for the `Left Window` key.
  const LEFT_WINDOW_KEY = 91

  // Constant for the `Closing Bracket` key.
  const CLOSE_BRACKET = 221

  // Constant for the `Decimal Point` key.
  const DECIMAL_POINT = 110

  // Constant for the `Forward Slash` key.
  const FORWARD_SLASH = 191

  // Constant for the `Open Bracket` key.
  const OPEN_BRACKET = 219

  // Constant for the `Single Quote` key.
  const SINGLE_QUOTE = 222

  // Constant for the `Grave Accent` key.
  const GRAVE_ACCENT = 192

  // Constant for the `Scroll Lock` key.
  const SCROLL_LOCK = 145

  // Constant for the `Pause Break` key.
  const PAUSE_BREAK = 19

  // Constant for the `Right Arrow` key.
  const RIGHT_ARROW = 39

  // Constant for the `Back Slash` key.
  const BACK_SLASH = 220

  // Constant for the `Equal Sign` key.
  const EQUAL_SIGN = 187

  // Constant for the `Semi Colon` key.
  const SEMI_COLON = 186

  // Constant for the `Down Arrow` key.
  const DOWN_ARROW = 40

  // Constant for the `Select Key` key.
  const SELECT_KEY = 93

  // Constant for the `Left Arrow` key.
  const LEFT_ARROW = 37

  // Constant for the `Page Down` key.
  const PAGE_DOWN = 34

  // Constant for the `Num Lock` key.
  const NUM_LOCK = 144

  // Constant for the `Subtract` key.
  const SUBTRACT = 109

  // Constant for the `Caps Lock` key.
  const CAPS_LOCK = 20

  // Constant for the `Multiply` key.
  const MULTIPLY = 106

  // Constant for the `Backspace` key.
  const BACKSPACE = 8

  // Constant for the `Up Arrow` key.
  const UP_ARROW = 38

  // Constant for the `Page Up` key.
  const PAGE_UP = 33

  // Constant for the `Numpad Divide` key.
  const DIVIDE = 111

  // Constant for the `Period` key.
  const PERIOD = 190

  // Constant for the comma `,` key.
  const COMMA = 188

  // Constant for the `Insert` key.
  const INSERT = 45

  // Constant for the `Delete` key.
  const DELETE = 46

  // Constant for the `Escape` key.
  const ESCAPE = 27

  // Constant for the `Shift` key.
  const SHIFT = 16

  // Constant for the `Space` key.
  const SPACE = 32

  // Constant for the `Enter` key.
  const ENTER = 13

  // Constant for the dash `Dash` key.
  const DASH = 189

  // Constant for the `Home` key.
  const HOME = 36

  // Constant for the `Control` key.
  const CTRL = 17

  // Constant for the `Add` key.
  const ADD = 107

  // Constant for the `Alt` key.
  const ALT = 18

  // Constant for the `End` key.
  const END = 35

  // Constant for the `Tab` key.
  const TAB = 9

  // Constant for the `0` key (numpad).
  const NUMPAD_0 = 96

  // Constant for the `1` key (numpad).
  const NUMPAD_1 = 97

  // Constant for the `2` key (numpad).
  const NUMPAD_2 = 98

  // Constant for the `3` key (numpad).
  const NUMPAD_3 = 99

  // Constant for the `4` key (numpad).
  const NUMPAD_4 = 100

  // Constant for the `5` key (numpad).
  const NUMPAD_5 = 101

  // Constant for the `6` key (numpad).
  const NUMPAD_6 = 102

  // Constant for the `7` key (numpad).
  const NUMPAD_7 = 103

  // Constant for the `8` key (numpad).
  const NUMPAD_8 = 104

  // Constant for the `9` key (numpad).
  const NUMPAD_9 = 105

  // Constant for the `0` key.
  const NUMBER_0 = 48

  // Constant for the `1` key.
  const NUMBER_1 = 49

  // Constant for the `2` key.
  const NUMBER_2 = 50

  // Constant for the `3` key.
  const NUMBER_3 = 51

  // Constant for the `4` key.
  const NUMBER_4 = 52

  // Constant for the `5` key.
  const NUMBER_5 = 53

  // Constant for the `6` key.
  const NUMBER_6 = 54

  // Constant for the `7` key.
  const NUMBER_7 = 55

  // Constant for the `8` key.
  const NUMBER_8 = 56

  // Constant for the `9` key.
  const NUMBER_9 = 57

  // Constant for the `F10` key.
  const F10 = 121

  // Constant for the `F11` key.
  const F11 = 122

  // Constant for the `F12` key.
  const F12 = 123

  // Constant for the `F1` key.
  const F1 = 112

  // Constant for the `F2` key.
  const F2 = 113

  // Constant for the `F3` key.
  const F3 = 114

  // Constant for the `F4` key.
  const F4 = 115

  // Constant for the `F5` key.
  const F5 = 116

  // Constant for the `F6` key.
  const F6 = 117

  // Constant for the `F7` key.
  const F7 = 118

  // Constant for the `F8` key.
  const F8 = 119

  // Constant for the `F9` key.
  const F9 = 120

  // Constant for the `A` key.
  const A = 65

  // Constant for the `B` key.
  const B = 66

  // Constant for the `C` key.
  const C = 67

  // Constant for the `D` key.
  const D = 68

  // Constant for the `E` key.
  const E = 69

  // Constant for the `F` key.
  const F = 70

  // Constant for the `G` key.
  const G = 71

  // Constant for the `H` key.
  const H = 72

  // Constant for the `I` key.
  const I = 73

  // Constant for the `J` key.
  const J = 74

  // Constant for the `K` key.
  const K = 75

  // Constant for the `L` key.
  const L = 76

  // Constant for the `M` key.
  const M = 77

  // Constant for the `N` key.
  const N = 78

  // Constant for the `O` key.
  const O = 79

  // Constant for the `P` key.
  const P = 80

  // Constant for the `Q` key.
  const Q = 81

  // Constant for the `R` key.
  const R = 82

  // Constant for the `S` key.
  const S = 83

  // Constant for the `T` key.
  const T = 84

  // Constant for the `U` key.
  const U = 85

  // Constant for the `V` key.
  const V = 86

  // Constant for the `W` key.
  const W = 87

  // Constant for the `X` key.
  const X = 88

  // Constant for the `Y` key.
  const Y = 89

  // Constant for the `Z` key.
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
  */
  fun preventDefault (event : Html.Event) : Void {
    `#{event.event}.preventDefault()`
  }

  /*
  Stops the propagation of the given event.

    Html.Event.stopPropagation(event)
  */
  fun stopPropagation (event : Html.Event) : Void {
    `#{event.event}.stopPropagation()`
  }
}
