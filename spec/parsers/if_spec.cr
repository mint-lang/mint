require "../spec_helper"

describe "If Expression" do
  subject if_expression

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "if", Parser::IfExpectedOpeningParentheses
  expect_error "if ", Parser::IfExpectedOpeningParentheses
  expect_error "if (", Parser::IfExpectedCondition
  expect_error "if (a", Parser::IfExpectedClosingParentheses
  expect_error "if (a)", Parser::IfExpectedTruthyOpeningBracket
  expect_error "if (a) ", Parser::IfExpectedTruthyOpeningBracket
  expect_error "if (a) {", Parser::IfExpectedTruthyExpression
  expect_error "if (a) { ", Parser::IfExpectedTruthyExpression
  expect_error "if (a) { a", Parser::IfExpectedTruthyClosingBracket
  expect_error "if (a) { a ", Parser::IfExpectedTruthyClosingBracket
  expect_error "if (a) { a }", Parser::IfExpectedElse
  expect_error "if (a) { a } ", Parser::IfExpectedElse
  expect_error "if (a) { a } else", Parser::IfExpectedFalsyOpeningBracket
  expect_error "if (a) { a } else ", Parser::IfExpectedFalsyOpeningBracket
  expect_error "if (a) { a } else {", Parser::IfExpectedFalsyExpression
  expect_error "if (a) { a } else { ", Parser::IfExpectedFalsyExpression
  expect_error "if (a) { a } else { a", Parser::IfExpectedFalsyClosingBracket
  expect_error "if (a) { a } else { a ", Parser::IfExpectedFalsyClosingBracket

  expect_ok "if (a) { b } else { c }"
end
