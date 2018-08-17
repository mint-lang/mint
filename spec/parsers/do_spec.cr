require "../spec_helper"

describe "Do Expression" do
  subject do_expression

  expect_ignore "a"
  expect_ignore "."
  expect_ignore "d"

  expect_error "sequence ", Mint::Parser::DoExpectedOpeningBracket
  expect_error "sequence ,", Mint::Parser::DoExpectedOpeningBracket
  expect_error "sequence a", Mint::Parser::DoExpectedOpeningBracket
  expect_error "sequence {", Mint::Parser::DoExpectedStatement
  expect_error "sequence { }", Mint::Parser::DoExpectedStatement
  expect_error "sequence { a", Mint::Parser::DoExpectedClosingBracket
  expect_error "sequence { a =", Mint::Parser::DoExpectedStatement
  expect_error "sequence { a = a", Mint::Parser::DoExpectedClosingBracket
  expect_error "sequence { a = a ", Mint::Parser::DoExpectedClosingBracket

  expect_ok "sequence { a }"
  expect_ok "sequence { a b }"
  expect_ok "sequence { a b }"
  expect_ok "sequence { a = x b = c }"
end
