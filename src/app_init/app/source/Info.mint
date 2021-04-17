component Info {
  property mainPath : String

  style info {
    font-size: calc(10px + 2vmin);
    color: #939DB0;
  }

  style path {
    font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New', monospace;
    font-style: italic;
    font-weight: 100;
    color: #E06C75;
  }

  fun render : Html {
    <p::info>
      <{ "Edit " }>

      <code::path>
        <{ mainPath }>
      </code>

      <{ " and save to reload." }>
    </p>
  }
}
