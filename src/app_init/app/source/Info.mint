component Info {
  property mainpath : String

  style info {
    font-size: calc(10px + 2vmin);
    color: #939db0;
  }

  style path {
    font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New', monospace;
    font-weight: 100;
    font-style: italic;
    color: #e06c75;
  }

  fun render : Html {
    <p::info>
      <{ "Edit " }>

      <code::path>
        <{ mainpath }>
      </code>

      <{ " and save to reload." }>
    </p>
  }
}
