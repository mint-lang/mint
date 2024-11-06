/*
A component to render `Html` in the `<head>`.

```
<Html.Portals.Head>
  <link rel="stylesheet" href="index.css"/>
</Html.Portals.Head>
```
*/
component Html.Portals.Head {
  /* The children to render. */
  property children : Array(Html) = []

  /* Renders the children in the `</head>`. */
  fun render : Html {
    `#{%createPortal%}(#{children}, document.head)`
  }
}
