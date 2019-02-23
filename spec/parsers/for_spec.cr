require "../spec_helper"

describe "For Expression" do
  subject for_expression

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "for ", Mint::Parser::ForExpectedOpeningParentheses
  expect_error "for (", Mint::Parser::ForExpectedOf
  expect_error "for (a", Mint::Parser::ForExpectedOf
  expect_error "for (a, b", Mint::Parser::ForExpectedOf
  expect_error "for (a, b of", Mint::Parser::ForExpectedSubject
  expect_error "for (a, b of a", Mint::Parser::ForExpectedClosingParentheses
  expect_error "for (a, b of a)", Mint::Parser::ForExpectedOpeningBracket
  expect_error "for (a, b of a) {", Mint::Parser::ForExpectedBody
  expect_error "for (a, b of a) { x", Mint::Parser::ForExpectedClosingBracket
  expect_error "for (a, b of a) { x } when", Mint::Parser::ForConditionExpectedOpeningBracket
  expect_error "for (a, b of a) { x } when {", Mint::Parser::ForConditionExpectedBody
  expect_error "for (a, b of a) { x } when { x", Mint::Parser::ForConditionExpectedClosingBracket

  expect_ok "for (a, b of a) { x }"
  expect_ok "for (a, b of a) { x } when { x }"
end
