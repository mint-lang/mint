require "../spec_helper"

describe "Do Expression" do
  subject parallel

  expect_ignore "a"
  expect_ignore "."
  expect_ignore "d"

  expect_error "parallel ", Mint::Parser::ParallelExpectedOpeningBracket
  expect_error "parallel ,", Mint::Parser::ParallelExpectedOpeningBracket
  expect_error "parallel a", Mint::Parser::ParallelExpectedOpeningBracket
  expect_error "parallel {", Mint::Parser::ParallelExpectedStatement
  expect_error "parallel { }", Mint::Parser::ParallelExpectedStatement
  expect_error "parallel { a = b", Mint::Parser::ParallelExpectedClosingBracket

  expect_ok "parallel { a = b }"
  expect_ok "parallel { a = x } then { y }"
  expect_ok "parallel { a = x b = x } then { y }"
end
