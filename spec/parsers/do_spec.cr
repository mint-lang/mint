require "../spec_helper"

describe "Do Expression" do
  subject do_expression

  expect_ignore "a"
  expect_ignore "."
  expect_ignore "d"

  expect_error "do ", Mint::Parser::DoExpectedOpeningBracket
  expect_error "do ,", Mint::Parser::DoExpectedOpeningBracket
  expect_error "do a", Mint::Parser::DoExpectedOpeningBracket
  expect_error "do {", Mint::Parser::DoExpectedStatement
  expect_error "do { }", Mint::Parser::DoExpectedStatement
  expect_error "do { a", Mint::Parser::DoExpectedClosingBracket
  expect_error "do { a =", Mint::Parser::DoExpectedStatement
  expect_error "do { a = a", Mint::Parser::DoExpectedClosingBracket
  expect_error "do { a = a ", Mint::Parser::DoExpectedClosingBracket

  expect_ok "do { a }"
  expect_ok "do { a b }"
  expect_ok "do { a b }"
  expect_ok "do { a = x b = c }"
end
