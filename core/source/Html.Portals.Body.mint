/* A React portal for the body. */
component Html.Portals.Body {
  /* The children to render into the portal */
  property children : Array(Html) = []

  /* Renders the children into the document's body. */
  fun render : Html {
    `_createPortal(#{children}, document.body)`
  }
}
