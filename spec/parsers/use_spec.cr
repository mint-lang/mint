require "../spec_helper"

describe "Component Use" do
  subject use

  expect_ignore "."
  expect_ignore "us"

  expect_error "use", Parser::UseExpectedProvider
  expect_error "use ", Parser::UseExpectedProvider
  expect_error "use Test", Parser::UseExpectedRecord
  expect_error "use Test ", Parser::UseExpectedRecord
  expect_error "use Test {}when", Parser::UseExpectedOpeningBracket
  expect_error "use Test {} when", Parser::UseExpectedOpeningBracket
  expect_error "use Test {} when ", Parser::UseExpectedOpeningBracket
  expect_error "use Test {} when {", Parser::UseExpectedExpression
  expect_error "use Test {} when { ", Parser::UseExpectedExpression
  expect_error "use Test {} when { a", Parser::UseExpectedClosingBracket
  expect_error "use Test {} when { a ", Parser::UseExpectedClosingBracket

  expect_ok "use Test {}"
  expect_ok "use Test {} when { true }"
end
