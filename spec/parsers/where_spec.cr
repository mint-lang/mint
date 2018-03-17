require "../spec_helper"

describe "Where" do
  subject where

  expect_error "where", Parser::WhereExpectedOpeningBracket
  expect_error "where ", Parser::WhereExpectedOpeningBracket
  expect_error "where {", Parser::WhereExpectedWhere
  expect_error "where { ", Parser::WhereExpectedWhere
  expect_error "where { a", Parser::WhereExpectedEqualSign
  expect_error "where { a ", Parser::WhereExpectedEqualSign
  expect_error "where { a =", Parser::WhereExpectedExpression
  expect_error "where { a = ", Parser::WhereExpectedExpression
  expect_error "where { a = a", Parser::WhereExpectedClosingBracket
  expect_error "where { a = a ", Parser::WhereExpectedClosingBracket
end
