/* This module provides functions for the window when writing tests. */
module Test.Window {
  /* Sets the horizontal scroll position of the window during a test. */
  fun setScrollLeft (context : Test.Context(a), to : Number) : Test.Context(a) {
    Test.Context.then(
      context,
      (subject : Dom.Element) : Promise(a) {
        Window.setScrollLeft(100)
        Promise.resolve(subject)
      })
  }

  /* Sets the vertical scroll position of the window during a test. */
  fun setScrollTop (context : Test.Context(a), to : Number) : Test.Context(a) {
    Test.Context.then(
      context,
      (subject : Dom.Element) : Promise(a) {
        Window.setScrollTop(100)
        Promise.resolve(subject)
      })
  }
}
