/* A React portal for the head. */
component Html.Portals.Head {
  /* The children to render into the portal */
  property children : Array(Html) = []

  /* Renders the children into the document's head. */
  fun render : Html {
    `#{%createPortal%}(#{children}, document.head)`
  }
}
