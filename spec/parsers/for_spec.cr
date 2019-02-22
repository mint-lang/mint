require "../spec_helper"

describe "For Expression" do
  subject for_expression

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "for", Mint::Parser::ForExpectedOpeningParentheses
  expect_error "for ", Mint::Parser::ForExpectedOpeningParentheses
  expect_error "for (", Mint::Parser::ForExpectedOf
  expect_error "for (a : A", Mint::Parser::ForExpectedOf
  expect_error "for (a : A, b : B", Mint::Parser::ForExpectedOf
  expect_error "for (a : A, b : B of", Mint::Parser::ForExpectedSubject
  expect_error "for (a : A, b : B of a", Mint::Parser::ForExpectedClosingParentheses
  expect_error "for (a : A, b : B of a)", Mint::Parser::ForExpectedOpeningBracket
  expect_error "for (a : A, b : B of a) {", Mint::Parser::ForExpectedBody
  expect_error "for (a : A, b : B of a) { x", Mint::Parser::ForExpectedClosingBracket
  expect_error "for (a : A, b : B of a) { x } when", Mint::Parser::ForConditionExpectedOpeningBracket
  expect_error "for (a : A, b : B of a) { x } when {", Mint::Parser::ForConditionExpectedBody
  expect_error "for (a : A, b : B of a) { x } when { x", Mint::Parser::ForConditionExpectedClosingBracket

  expect_ok "for (a : A, b : B of a) { x }"
  expect_ok "for (a : A, b : B of a) { x } when { x }"
end
