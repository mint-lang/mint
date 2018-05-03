require "../spec_helper"

describe "With" do
  subject with_expression

  expect_ignore ""
  expect_ignore ".."
  expect_ignore "a"
  expect_ignore "asdasd"

  expect_error "with", Mint::Parser::WithExpectedModule
  expect_error "with A", Mint::Parser::WithExpectedOpeningBracket
  expect_error "with A ", Mint::Parser::WithExpectedOpeningBracket
  expect_error "with A {", Mint::Parser::WithExpectedExpression
  expect_error "with A { ", Mint::Parser::WithExpectedExpression
  expect_error "with A { void", Mint::Parser::WithExpectedClosingBracket
  expect_error "with A { void ", Mint::Parser::WithExpectedClosingBracket

  expect_ok "withA{void}"
  expect_ok "with A { void }"
end
