require "../spec_helper"

describe "Html Attribute" do
  subject html_attribute

  expect_ignore " "
  expect_ignore "."
  expect_ignore "0"
  expect_ignore "??"

  expect_error "name", Parser::HtmlAttributeExpectedEqualSign
  expect_error "name=", Parser::HtmlAttributeExpectedOpeningBracket
  expect_error "name={", Parser::HtmlAttributeExpectedExpression
  expect_error "name={a", Parser::HtmlAttributeExpectedClosingBracket

  expect_ok %(test="asd")
  expect_ok %(test={a})
  expect_ok %(test={ a })
  expect_ok %(data-text={a})
end
