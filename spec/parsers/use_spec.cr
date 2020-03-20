require "../spec_helper"

describe "Component Use" do
  subject use

  expect_ignore "."
  expect_ignore "us"

  expect_error "use ", Mint::Parser::UseExpectedProvider
  expect_error "use Test", Mint::Parser::UseExpectedRecord
  expect_error "use Test ", Mint::Parser::UseExpectedRecord
  expect_error "use Test {}when", Mint::Parser::UseExpectedOpeningBracket
  expect_error "use Test {} when", Mint::Parser::UseExpectedOpeningBracket
  expect_error "use Test {} when ", Mint::Parser::UseExpectedOpeningBracket
  expect_error "use Test {} when {", Mint::Parser::UseExpectedExpression
  expect_error "use Test {} when { ", Mint::Parser::UseExpectedExpression
  expect_error "use Test {} when { a", Mint::Parser::UseExpectedClosingBracket
  expect_error "use Test {} when { a ", Mint::Parser::UseExpectedClosingBracket

  expect_ok "use Test {}"
  expect_ok "use Test {} when { true }"
end
