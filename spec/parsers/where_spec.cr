require "../spec_helper"

describe "Where" do
  subject where

  expect_error "where", Mint::Parser::WhereExpectedOpeningBracket
  expect_error "where ", Mint::Parser::WhereExpectedOpeningBracket
  expect_error "where {", Mint::Parser::WhereExpectedWhere
  expect_error "where { ", Mint::Parser::WhereExpectedWhere
  expect_error "where { a", Mint::Parser::WhereExpectedEqualSign
  expect_error "where { a ", Mint::Parser::WhereExpectedEqualSign
  expect_error "where { a =", Mint::Parser::WhereExpectedExpression
  expect_error "where { a = ", Mint::Parser::WhereExpectedExpression
  expect_error "where { a = a", Mint::Parser::WhereExpectedClosingBracket
  expect_error "where { a = a ", Mint::Parser::WhereExpectedClosingBracket
end
