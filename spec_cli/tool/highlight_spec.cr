require "../spec_helper"

context "highlight" do
  before_all do
    FileUtils.rm_rf "my-project"
    run ["init", "my-project"]
    FileUtils.cd "my-project"
  end

  after_all do
    FileUtils.cd ".."
    FileUtils.rm_rf "my-project"
  end

  it "displays help with '--help' flag" do
    expect_output ["tool", "highlight", "--help"], <<-TEXT
      Usage:
        ×××× tool highlight [flags...] <path> [arg...]

      Returns the syntax highlighted version of the given file.

      Flags:
        --help           # Displays help for the current command.
        --html           # If specified, print the highlighted code as HTML.

      Arguments:
        path (required)  # The path to the file.
      TEXT
  end

  it "highlights file" do
    expect_output ["tool", "highlight", "source/Main.mint"], <<-TEXT
      // This is the component which gets rendered on the screen
      component Main {
        // Styles for the root element.
        style root {
          background-image: url(\#{@asset(../assets/bottom-left.png)}),
                            url(\#{@asset(../assets/bottom-center.png)}),
                            url(\#{@asset(../assets/bottom-right.png)}),
                            url(\#{@asset(../assets/top-left.png)}),
                            url(\#{@asset(../assets/top-center.png)}),
                            url(\#{@asset(../assets/top-right.png)});

          background-position: calc(100% + 15px) 100%, 50% 100%, -20px 100%,
                               -20px 0, 50% 0, calc(100% + 15px) 0;

          background-repeat: no-repeat;
          background-color: white;

          box-sizing: border-box;
          min-height: 100vh;
          padding: 100px;
          display: grid;
          width: 100vw;

          font-family: Noto Sans, sans;
          background-color: #FFF;
          color: #333;

          @media (max-width: 600px) {
            padding: 10px;
          }
        }

        // Styles for the content.
        style content {
          justify-content: center;
          flex-direction: column;
          align-items: center;
          display: flex;

          @media (max-width: 600px) {
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(3px);

            justify-content: space-between;
            padding: 20px;
          }
        }

        // Styles for the footer.
        style footer {
          border-top: 3px double rgba(0,0,0,0.1);
          padding-top: 30px;
          margin-top: 30px;
          max-width: 72ch;
          width: 100%;

          text-align: center;
          font-size: 20px;

          small {
            margin-top: 5px;
            font-size: 14px;
            display: block;
            opacity: 0.75;
          }
        }

        // Renders the component.
        fun render : Html {
          <div::root>
            <div::content>
              <Content/>

              <div::footer>
                @svg(../assets/logo.svg)
                <small>"2018 - \#{Time.year(Time.now())}"</small>
              </div>
            </div>
          </div>
        }
      }
      TEXT
  end

  it "highlights file (html)" do
    expect_output ["tool", "highlight", "source/Main.mint", "--html"], <<-TEXT
      <span class="comment">// This is the component which gets rendered on the screen</span>
      <span class="keyword">component</span> <span class="type">Main</span> {
        <span class="comment">// Styles for the root element.</span>
        <span class="keyword">style</span> <span class="variable">root</span> {
          <span class="property">background-image</span>: url(\#{<span class="keyword">@asset</span>(../assets/bottom-left.png)}),
                            url(\#{<span class="keyword">@asset</span>(../assets/bottom-center.png)}),
                            url(\#{<span class="keyword">@asset</span>(../assets/bottom-right.png)}),
                            url(\#{<span class="keyword">@asset</span>(../assets/top-left.png)}),
                            url(\#{<span class="keyword">@asset</span>(../assets/top-center.png)}),
                            url(\#{<span class="keyword">@asset</span>(../assets/top-right.png)});

          <span class="property">background-position</span>: calc(100% + 15px) 100%, 50% 100%, -20px 100%,
                               -20px 0, 50% 0, calc(100% + 15px) 0;

          <span class="property">background-repeat</span>: no-repeat;
          <span class="property">background-color</span>: white;

          <span class="property">box-sizing</span>: border-box;
          <span class="property">min-height</span>: 100vh;
          <span class="property">padding</span>: 100px;
          <span class="property">display</span>: grid;
          <span class="property">width</span>: 100vw;

          <span class="property">font-family</span>: Noto Sans, sans;
          <span class="property">background-color</span>: #FFF;
          <span class="property">color</span>: #333;

          @media (max-width: 600px) {
            <span class="property">padding</span>: 10px;
          }
        }

        <span class="comment">// Styles for the content.</span>
        <span class="keyword">style</span> <span class="variable">content</span> {
          <span class="property">justify-content</span>: center;
          <span class="property">flex-direction</span>: column;
          <span class="property">align-items</span>: center;
          <span class="property">display</span>: flex;

          @media (max-width: 600px) {
            <span class="property">background</span>: rgba(255, 255, 255, 0.5);
            <span class="property">backdrop-filter</span>: blur(3px);

            <span class="property">justify-content</span>: space-between;
            <span class="property">padding</span>: 20px;
          }
        }

        <span class="comment">// Styles for the footer.</span>
        <span class="keyword">style</span> <span class="variable">footer</span> {
          <span class="property">border-top</span>: 3px double rgba(0,0,0,0.1);
          <span class="property">padding-top</span>: 30px;
          <span class="property">margin-top</span>: 30px;
          <span class="property">max-width</span>: 72ch;
          <span class="property">width</span>: 100%;

          <span class="property">text-align</span>: center;
          <span class="property">font-size</span>: 20px;

          small {
            <span class="property">margin-top</span>: 5px;
            <span class="property">font-size</span>: 14px;
            <span class="property">display</span>: block;
            <span class="property">opacity</span>: 0.75;
          }
        }

        <span class="comment">// Renders the component.</span>
        <span class="keyword">fun</span> render : <span class="type">Html</span> {
          &lt;<span class="namespace">div</span>::root&gt;
            &lt;<span class="namespace">div</span>::content&gt;
              &lt;<span class="type">Content</span>/&gt;

              &lt;<span class="namespace">div</span>::footer&gt;
                <span class="keyword">@svg</span>(../assets/logo.svg)
                &lt;<span class="namespace">small</span>&gt;<span class="string">&quot;2018 -</span><span class="string"> \#{</span><span class="type">Time</span>.<span class="variable">year</span>(<span class="type">Time</span>.<span class="variable">now</span>())<span class="string">}&quot;</span>&lt;/<span class="namespace">small</span>&gt;
              &lt;/<span class="namespace">div</span>&gt;
            &lt;/<span class="namespace">div</span>&gt;
          &lt;/<span class="namespace">div</span>&gt;
        }
      }
      TEXT
  end

  it "missing file" do
    expect_output ["tool", "highlight", "src/Main.mint"], <<-TEXT
      Mint - Highlighting
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚠ File "src/Main.mint" not found.
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      There was an error, exiting...
      TEXT
  end
end
