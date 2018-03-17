require "../spec_helper"

describe "With" do
  subject with_expression

  expect_ignore ""
  expect_ignore ".."
  expect_ignore "a"
  expect_ignore "asdasd"

  expect_error "with", Parser::WithExpectedModule
  expect_error "with A", Parser::WithExpectedOpeningBracket
  expect_error "with A ", Parser::WithExpectedOpeningBracket
  expect_error "with A {", Parser::WithExpectedExpression
  expect_error "with A { ", Parser::WithExpectedExpression
  expect_error "with A { void", Parser::WithExpectedClosingBracket
  expect_error "with A { void ", Parser::WithExpectedClosingBracket

  expect_ok "withA{void}"
  expect_ok "with A { void }"
end
