require "../spec_helper"

describe "Component Get" do
  subject get

  expect_ignore "a"
  expect_ignore "."
  expect_ignore "ge"

  expect_error "get", Parser::GetExpectedName
  expect_error "get ", Parser::GetExpectedName
  expect_error "get a", Parser::GetExpectedColon
  expect_error "get a ", Parser::GetExpectedColon
  expect_error "get a :", Parser::GetExpectedType
  expect_error "get a : ", Parser::GetExpectedType
  expect_error "get a : a", Parser::GetExpectedType
  expect_error "get a : T", Parser::GetExpectedOpeningBracket
  expect_error "get a : T ", Parser::GetExpectedOpeningBracket
  expect_error "get a : T {", Parser::GetExpectedExpression
  expect_error "get a : T { ", Parser::GetExpectedExpression
  expect_error "get a : T { a .", Parser::GetExpectedClosingBracket

  expect_ok "get a : T { a}"
  expect_ok "get a : T { a }"
end
