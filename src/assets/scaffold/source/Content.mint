component Content {
  // Styles for the root element.
  style root {
    max-width: 72ch;
    font-size: 20px;
    color: #333;

    code {
      padding: 0.15em 0.3em 0.1em;
      border: 1px solid #EEE;
      border-radius: 0.15em;
      background: #F6F6F6;
      font-size: 0.9em;
    }

    a {
      color: #56A972;
    }

    h3 {
      margin-top: 0;
    }

    li + li {
      margin-top: 0.5em;
    }

    blockquote {
      border-left: 3px solid #EEE;
      font-style: italic;
      padding-left: 15px;
      font-size: 0.8em;

      margin-bottom: 0;
      margin-top: 30px;
      margin-left: 0;

      p {
        margin: 0;
      }
    }

    @media (max-width: 600px) {
      font-size: 16px;

      ul {
        padding-left: 20px;
      }
    }
  }

  // Renders the component.
  fun render : Html {
    <div::root>
      <<#MARKDOWN
      ### Hello there 👋

      Congratulations 🎉 You just made your first step of creating a **single
      page application** with Mint by generating this example skeleton.

      You can edit any `.mint` file to make changes which will be reflected
      here (this page reloads when something changes).

      Here are some links which you might find helpful going forward:

      * The [interactive tutorial] to learn Mint 🧑‍🎓
      * The [guides] with information on best practices 📚
      * The documentation of the [standard library] 📜
      * The [RealWorld] example application 💡

      If you get stuck 🤯 you are welcome to ask questions on our [discord
      server] 💬

      > P.S. If you want to initialize an empty project (without this stuff)
      use the `--bare` flag.

      [RealWorld]: https://github.com/mint-lang/mint-realworld
      [interactive tutorial]: https://mint-lang.com/tutorial
      [discord server]: https://discord.gg/EtApG7BGfy
      [standard library]: https://mint-lang.com/api
      [guides]: https://mint-lang.com/guides
      MARKDOWN
    </div>
  }
}
