require "../spec_helper"

describe "Html Element" do
  subject html_element

  expect_ignore "asd"
  expect_ignore "< "

  expect_error "<a", Mint::Parser::HtmlElementExpectedClosingBracket
  expect_error "<a::", Mint::Parser::HtmlElementExpectedStyle
  expect_error "<a as", Mint::Parser::HtmlElementExpectedReference
  expect_error "<a::a", Mint::Parser::HtmlElementExpectedClosingBracket
  expect_error "<a::a ", Mint::Parser::HtmlElementExpectedClosingBracket
  expect_error "<a::a a={a}b={b}", Mint::Parser::HtmlElementExpectedClosingBracket

  expect_ok "<a::a/>"
  expect_ok "<a::a></a>"
  expect_ok "<a > </a>"
  expect_ok "<a > <b></b> </a>"
  expect_ok "<a::b ></a>"
  expect_ok "<a::b a={a} b={b} ></a>"
  expect_ok "<a::b data-id={a} b={b} ></a>"
end
