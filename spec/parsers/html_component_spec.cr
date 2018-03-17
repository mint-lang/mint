require "../spec_helper"

describe "Html Component" do
  subject html_component

  expect_error "<T.", Parser::HtmlComponentExpectedType
  expect_error "<T>", Parser::HtmlComponentExpectedClosingTag
  expect_error "<T", Parser::HtmlComponentExpectedClosingBracket
  expect_error "<T a-s={a}>", Parser::HtmlAttributeExpectedEqualSign
  expect_error "<T a={a}b={b}>", Parser::HtmlComponentExpectedClosingTag

  expect_ok "<T/>"
  expect_ok "<T.T/>"
  expect_ok "<T></T>"
  expect_ok "<T.T></T.T>"
  expect_ok "<T a={a}></T>"
  expect_ok "<T><test></test></T>"
  expect_ok "<T><test></test> <test></test></T>"
end
