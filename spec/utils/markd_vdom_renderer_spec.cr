require "../spec_helper"

describe Mint::VDOMRenderer do
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
    {"# Heading 1", "_h('h1',{},[`Heading 1`])"},
    {"## Heading 2", "_h('h2',{},[`Heading 2`])"},
    {"### Heading 3", "_h('h3',{},[`Heading 3`])"},
    {"#### Heading 4", "_h('h4',{},[`Heading 4`])"},
    {"##### Heading 5", "_h('h5',{},[`Heading 5`])"},
    {"###### Heading 6", "_h('h6',{},[`Heading 6`])"},
    {"Paragraph", "_h('p',{},[`Paragraph`])"},
    {"_em_", "_h('p',{},[_h('em',{},[`em`])])"},
    {"**strong**", "_h('p',{},[_h('strong',{},[`strong`])])"},
    {"foo\nbaz", "_h('p',{},[`foo`,`\n`,`baz`])"},
    {"foo\\\nbar", "_h('p',{},[`foo`,_h('br',{},[]),`bar`])"},
    {"`code`", "_h('p',{},[_h('code',{},[`code`])])"},
    {"```html\ncode\n```", %(_h('pre',{},[_h('code',{class:"language-html"},[`code`])]))},
    {"-----", "_h('hr',{},[])"},
    {"> qoute", "_h('blockquote',{},[_h('p',{},[`qoute`])])"},
    {"* item 1\n* item 2", "_h('ul',{},[_h('li',{},[`item 1`]),_h('li',{},[`item 2`])])"},
    {"[link](url)", %(_h('p',{},[_h('a',{href:"url"},[`link`])]))},
    {"![alt](url)", %(_h('p',{},[_h('img',{src:"url",alt:"alt"},[])]))},
    {html_block, %(`#{html_block}`)},
    {"<del>*foo*</del>", "_h('p',{},[`<del>`,_h('em',{},[`foo`]),`</del>`])"},
    {"<style>*foo*</style>", "`<style>*foo*</style>`"},
  ].each do |(markdown, expected)|
    context markdown do
      it "renders correctly" do
        options = Markd::Options.new
        document = Markd::Parser.parse(markdown, options)

        renderer = Mint::VDOMRenderer.new
        renderer.render(document.first_child).should eq(expected)
      end
    end
  end
end
