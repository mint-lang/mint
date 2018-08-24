require "../spec_helper"

describe "Do Expression" do
  subject sequence

  expect_ignore "a"
  expect_ignore "."
  expect_ignore "d"

  expect_error "sequence ", Mint::Parser::SequenceExpectedOpeningBracket
  expect_error "sequence ,", Mint::Parser::SequenceExpectedOpeningBracket
  expect_error "sequence a", Mint::Parser::SequenceExpectedOpeningBracket
  expect_error "sequence {", Mint::Parser::SequenceExpectedStatement
  expect_error "sequence { }", Mint::Parser::SequenceExpectedStatement
  expect_error "sequence { a", Mint::Parser::SequenceExpectedClosingBracket
  expect_error "sequence { a =", Mint::Parser::SequenceExpectedStatement
  expect_error "sequence { a = a", Mint::Parser::SequenceExpectedClosingBracket
  expect_error "sequence { a = a ", Mint::Parser::SequenceExpectedClosingBracket

  expect_ok "sequence { a }"
  expect_ok "sequence { a b }"
  expect_ok "sequence { a b }"
  expect_ok "sequence { a = x b = c }"
end
