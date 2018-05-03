require "../spec_helper"

describe "Html Attribute" do
  subject html_attribute

  expect_ignore " "
  expect_ignore "."
  expect_ignore "0"
  expect_ignore "??"

  expect_error "name", Mint::Parser::HtmlAttributeExpectedEqualSign
  expect_error "name=", Mint::Parser::HtmlAttributeExpectedOpeningBracket
  expect_error "name={", Mint::Parser::HtmlAttributeExpectedExpression
  expect_error "name={a", Mint::Parser::HtmlAttributeExpectedClosingBracket

  expect_ok %(test="asd")
  expect_ok %(test={a})
  expect_ok %(test={ a })
  expect_ok %(data-text={a})
end
