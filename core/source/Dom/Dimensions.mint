/* Record for the dimensions of an element on the screen. */
type Dom.Dimensions {
  height : Number,
  bottom : Number,
  width : Number,
  right : Number,
  left : Number,
  top : Number,
  x : Number,
  y : Number
}

/*
This module provides functions for working with dimensions in the [DOM].

[DOM]: https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model.
*/
module Dom.Dimensions {
  /*
  Returns an empty `Dom.Dimensions` record.

    Dom.Dimensions.empty()
  */
  fun empty : Dom.Dimensions {
    {
      bottom: 0,
      height: 0,
      width: 0,
      right: 0,
      left: 0,
      top: 0,
      x: 0,
      y: 0
    }
  }
}
