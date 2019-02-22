/* Utility functions for the window when testing. */
module Test.Window {
  /* Sets the horizontal scroll position of the window during a test. */
  fun setScrollLeft (to : Number, context : Test.Context(a)) : Test.Context(a) {
    Test.Context.then(
      (subject : Dom.Element) : Promise(Never, a) {
        try {
          Window.setScrollLeft(100)
          Promise.resolve(subject)
        }
      },
      context)
  }

  /* Sets the vertical scroll position of the window during a test. */
  fun setScrollTop (to : Number, context : Test.Context(a)) : Test.Context(a) {
    Test.Context.then(
      (subject : Dom.Element) : Promise(Never, a) {
        try {
          Window.setScrollTop(100)
          Promise.resolve(subject)
        }
      },
      context)
  }
}
