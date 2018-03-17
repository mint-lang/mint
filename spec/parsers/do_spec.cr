require "../spec_helper"

describe "Do Expression" do
  subject do_expression

  expect_ignore "a"
  expect_ignore "."
  expect_ignore "d"

  expect_error "do ", Parser::DoExpectedOpeningBracket
  expect_error "do ,", Parser::DoExpectedOpeningBracket
  expect_error "do a", Parser::DoExpectedOpeningBracket
  expect_error "do {", Parser::DoExpectedStatement
  expect_error "do { }", Parser::DoExpectedStatement
  expect_error "do { a", Parser::DoExpectedClosingBracket
  expect_error "do { a =", Parser::DoExpectedStatement
  expect_error "do { a = a", Parser::DoExpectedClosingBracket
  expect_error "do { a = a ", Parser::DoExpectedClosingBracket

  expect_ok "do { a }"
  expect_ok "do { a b }"
  expect_ok "do { a b }"
  expect_ok "do { a = x b = c }"
end
