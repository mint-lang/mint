require "../spec_helper"

describe "If Expression" do
  subject if_expression

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "if", Mint::Parser::IfExpectedOpeningParentheses
  expect_error "if ", Mint::Parser::IfExpectedOpeningParentheses
  expect_error "if (", Mint::Parser::IfExpectedCondition
  expect_error "if (a", Mint::Parser::IfExpectedClosingParentheses
  expect_error "if (a)", Mint::Parser::IfExpectedTruthyOpeningBracket
  expect_error "if (a) ", Mint::Parser::IfExpectedTruthyOpeningBracket
  expect_error "if (a) {", Mint::Parser::IfExpectedTruthyExpression
  expect_error "if (a) { ", Mint::Parser::IfExpectedTruthyExpression
  expect_error "if (a) { a", Mint::Parser::IfExpectedTruthyClosingBracket
  expect_error "if (a) { a ", Mint::Parser::IfExpectedTruthyClosingBracket
  expect_error "if (a) { a }", Mint::Parser::IfExpectedElse
  expect_error "if (a) { a } ", Mint::Parser::IfExpectedElse
  expect_error "if (a) { a } else", Mint::Parser::IfExpectedFalsyOpeningBracket
  expect_error "if (a) { a } else ", Mint::Parser::IfExpectedFalsyOpeningBracket
  expect_error "if (a) { a } else {", Mint::Parser::IfExpectedFalsyExpression
  expect_error "if (a) { a } else { ", Mint::Parser::IfExpectedFalsyExpression
  expect_error "if (a) { a } else { a", Mint::Parser::IfExpectedFalsyClosingBracket
  expect_error "if (a) { a } else { a ", Mint::Parser::IfExpectedFalsyClosingBracket

  expect_ok "if (a) { b } else { c }"
  expect_ok "if ( a ) { b } else { c }"
  expect_ok "if (a) { b } else if (x) { y } else { z }"
end
