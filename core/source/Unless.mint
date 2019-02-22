/* Renders the children if the given condition is false. */
component Unless {
  /* The children to render. */
  property children : Array(Html) = []

  /* The condition. */
  property condition : Bool = true

  fun render : Array(Html) {
    if (!condition) {
      children
    } else {
      []
    }
  }
}
