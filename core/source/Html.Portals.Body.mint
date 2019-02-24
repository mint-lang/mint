/* A React portal for the body. */
component Html.Portals.Body {
  /* The children to render into the portal */
  property children : Array(Html) = []

  /* Renders the children into the documents body. */
  fun render : Html {
    `_createPortal(this.children, document.body)`
  }
}
