require "./spec_helper"

describe Mint::HtmlSnippet do
  context "CRLF" do
    it "renders correctly" do
      expected =
        "<div class=\"snippet\">\n  <div class='file'>\n    FILE\n  </div>\n  <div class=\"grid\">\n    <div class=\"line-numbers\">\n        <div class='line-number'>1</div>\n<div class='line-number'>2</div>\n<div class='line-number'>3</div>\n    </div>\n    <pre><highlighted>line1</highlighted>\n<highlighted>line2</highlighted>\n<highlighted>line2</highlighted></pre>\n  </div>\n</div>"

      node =
        Mint::Ast::Node.new(
          input: Mint::Ast::Data.new(
            input: "line1\r\nline2\r\nline2",
            file: "FILE"),
          from: 0,
          to: 23)

      Mint::HtmlSnippet.render(node).should eq(expected)
    end
  end

  context "LF" do
    it "renders correctly" do
      expected =
        "<div class=\"snippet\">\n  <div class='file'>\n    FILE\n  </div>\n  <div class=\"grid\">\n    <div class=\"line-numbers\">\n        <div class='line-number'>1</div>\n<div class='line-number'>2</div>\n<div class='line-number'>3</div>\n    </div>\n    <pre><highlighted>line1</highlighted>\n<highlighted>line2</highlighted>\n<highlighted>line2</highlighted></pre>\n  </div>\n</div>"

      node =
        Mint::Ast::Node.new(
          input: Mint::Ast::Data.new(
            input: "line1\nline2\nline2",
            file: "FILE"),
          from: 0,
          to: 23)

      Mint::HtmlSnippet.render(node).should eq(expected)
    end
  end
end
