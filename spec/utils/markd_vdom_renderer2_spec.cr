require "../spec_helper"

module Mint
  class Compiler
    describe VDOMRenderer2 do
      html_block =
        <<-HTML
    <table>
      <tr>
        <td>
               hi
        </td>
      </tr>
    </table>
    HTML

      [
        {"**strong**", "A('p', {}, [A('strong', {}, [`strong`])])"},
        {"> quote", "A('blockquote', {}, [A('p', {}, [`quote`])])"},
        {"`code`", "A('p', {}, [A('code', {}, [`code`])])"},
        {"<style>*foo*</style>", "`<style>*foo*</style>`"},
        {"###### Heading 6", "A('h6', {}, [`Heading 6`])"},
        {"##### Heading 5", "A('h5', {}, [`Heading 5`])"},
        {"#### Heading 4", "A('h4', {}, [`Heading 4`])"},
        {"### Heading 3", "A('h3', {}, [`Heading 3`])"},
        {"## Heading 2", "A('h2', {}, [`Heading 2`])"},
        {"# Heading 1", "A('h1', {}, [`Heading 1`])"},
        {"_em_", "A('p', {}, [A('em', {}, [`em`])])"},
        {"Paragraph", "A('p', {}, [`Paragraph`])"},
        {html_block, %(`#{html_block}`)},
        {"-----", "A('hr', {}, [])"},
        {
          "foo\nbaz",
          <<-TEXT
      A('p', {}, [
        `foo`,
        `\n`,
        `baz`
      ])
      TEXT
        },
        {
          "foo\\\nbar",
          <<-TEXT
      A('p', {}, [
        `foo`,
        A('br', {}, []),
        `bar`
      ])
      TEXT
        },
        {
          "```html\ncode\n```",
          <<-TEXT
      A('pre', {}, [A('code', {
        class: "language-html"
      }, [`code`])])
      TEXT
        },
        {
          "* item 1\n* item 2",
          <<-TEXT
      A('ul', {}, [
        A('li', {}, [`item 1`]),
        A('li', {}, [`item 2`])
      ])
      TEXT
        },
        {
          "[link](url)",
          <<-TEXT
      A('p', {}, [A('a', {
        href: "url"
      }, [`link`])])
      TEXT
        },
        {
          "![alt](url)",
          <<-TEXT
      A('p', {}, [A('img', {
        src: "url",
        alt: "alt"
      }, [])])
      TEXT
        },
        {
          "<del>*foo*</del>",
          <<-TEXT
      A('p', {}, [
        `<del>`,
        A('em', {}, [`foo`]),
        `</del>`
      ])
      TEXT
        },
      ].each do |(markdown, expected)|
        context markdown do
          it "renders correctly" do
            document =
              Markd::Parser.parse(markdown, Markd::Options.new)

            renderer =
              VDOMRenderer2.new

            js =
              Js.new(false)

            class_pool =
              NamePool(Ast::Node | Builtin, Set(Ast::Node) | Bundle).new('A'.pred.to_s)

            pool =
              NamePool(Ast::Node | Decoder | Encoder | Variable | String, Set(Ast::Node) | Bundle).new

            js_renderer =
              Renderer.new(
                bundles: {} of Set(Ast::Node) | Bundle => Set(Ast::Node),
                deferred_path: ->(_node : Set(Ast::Node) | Bundle) { "" },
                asset_path: ->(_node : Ast::Node) { "" },
                class_pool: class_pool,
                base: Bundle::Index,
                pool: pool)

            node =
              VDOMRenderer2
                .render(
                  node: renderer.render(document, "___SEPARATOR___", Highlight::None).children.first,
                  replacements: [] of Compiled,
                  separator: "",
                  js: js)

            result =
              js_renderer.render(node)

            begin
              result.should eq(expected.strip)
            rescue error
              fail diff(expected, result)
            end
          end
        end
      end
    end
  end
end
