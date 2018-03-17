require "../spec_helper"

describe "Parenthesized Expression" do
  subject parenthesized_expression

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "(", Parser::ParenthesizedExpressionExpectedExpression
  expect_error "(a", Parser::ParenthesizedExpressionExpectedClosingParentheses

  expect_ok "(a)"
  expect_ok "( a )"
end
