require "../spec_helper"

describe "Html Expression" do
  subject html_expression

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"
  expect_ignore "<"

  expect_error "<{", Mint::Parser::HtmlExpressionExpectedClosingTag
  expect_error "<{ ", Mint::Parser::HtmlExpressionExpectedClosingTag
  expect_error "<{ a", Mint::Parser::HtmlExpressionExpectedClosingTag
  expect_error "<{ a ", Mint::Parser::HtmlExpressionExpectedClosingTag

  expect_ok "<{ a }>"
end
