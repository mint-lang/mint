require "./spec_helper"

describe Mint::StyleBuilder do
  it "builds simple styles with css prefix" do
    example =
      <<-MINT
        style test {
          div, p {
            background: red;

            span, strong {
              pre {
                color: \#{"red"};
              }
            }

            span, strong {
              pre {
                background: white;

                @media (screen) {
                  color: blue;

                  a {
                    border: 1px solid red;
                  }
                }
              }
            }
          }

          @media (screen) {
            div, p {
              font-size: 30px;

              if (true) {
                color: red;
              }
            }
          }

          @media (screen) {
            div, p {
              color: blue;
            }

            @media (print) {
              div, p {
                color: black;
                border-radius: \#{10}px;
              }
            }
          }
        }
      MINT

    parser =
      Mint::Parser.new(example.strip, "test.mint")

    style =
      parser.style.should_not be_nil

    builder = Mint::StyleBuilder.new(css_prefix: "foo-")
    builder.process(style)

    compiled = builder.compile
    compiled.should contain(".foo-a div span pre a {")
  end
end
