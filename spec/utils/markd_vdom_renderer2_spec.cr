require "../spec_helper"

describe Mint::Compiler2::VDOMRenderer2 do
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
          Mint::Compiler2::VDOMRenderer2.new

        js =
          Mint::Compiler2::Js.new(false)

        class_pool =
          Mint::NamePool(Mint::Ast::Node | Mint::Compiler2::Builtin, Mint::Ast::Node | Mint::Compiler2::Bundle).new('A'.pred.to_s)

        pool =
          Mint::NamePool(Mint::Ast::Node | Mint::Compiler2::Decoder | Mint::Compiler2::Encoder | Mint::Compiler2::Variable | String, Mint::Ast::Node | Mint::Compiler2::Bundle).new

        js_renderer =
          Mint::Compiler2::Renderer.new(
            deferred_path: ->(_node : Mint::Ast::Node | Mint::Compiler2::Bundle) { "" },
            bundle_path: ->(_node : Mint::Ast::Node | Mint::Compiler2::Bundle) { "" },
            references: Mint::ReferencesTracker.new,
            base: Mint::Compiler2::Bundle::Index,
            class_pool: class_pool,
            pool: pool)

        node =
          Mint::Compiler2::VDOMRenderer2
            .render(
              node: renderer.render(document, "___SEPARATOR___", false).children.first,
              replacements: [] of Mint::Compiler2::Compiled,
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
