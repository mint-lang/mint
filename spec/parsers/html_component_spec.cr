require "../spec_helper"

describe "Html Component" do
  subject html_component

  expect_error "<T.", Mint::Parser::HtmlComponentExpectedType
  expect_error "<T>", Mint::Parser::HtmlComponentExpectedClosingTag
  expect_error "<T", Mint::Parser::HtmlComponentExpectedClosingBracket
  expect_error "<T as", Mint::Parser::HtmlComponentExpectedReference
  expect_error "<T a-s={a}>", Mint::Parser::HtmlAttributeExpectedEqualSign
  expect_error "<T a={a}b={b}>", Mint::Parser::HtmlComponentExpectedClosingTag

  expect_ok "<T/>"
  expect_ok "<T.T/>"
  expect_ok "<T></T>"
  expect_ok "<T.T></T.T>"
  expect_ok "<T a={a}></T>"
  expect_ok "<T><test></test></T>"
  expect_ok "<T><test></test> <test></test></T>"
end
