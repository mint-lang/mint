/*
A component to render `Html` in the `<body>`.

```
<Html.Portals.Body>
  "Hello World!"
</Html.Portals.Body>
```
*/
component Html.Portals.Body {
  /* The children to render. */
  property children : Array(Html) = []

  /* Renders the children in the `</body>`. */
  fun render : Html {
    `#{%createPortal%}(#{children}, document.body)`
  }
}
