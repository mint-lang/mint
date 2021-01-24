component Link {
  property href : String
  property children : Array(Html) = []

  style link {
    color: rgb(221, 221, 221);
    text-decoration: none;
    font-size: calc(10px + 2vmin);

    &:hover {
      text-decoration: underline;
    }
  }

  fun render : Html {
    <a::link href="#{href}" target="_blank">
      <{ children }>
    </a>
  }
}
