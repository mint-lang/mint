require "../spec_helper"

describe "Component Get" do
  subject get

  expect_ignore "a"
  expect_ignore "."
  expect_ignore "ge"

  expect_error "get ", Mint::Parser::GetExpectedName
  expect_error "get a", Mint::Parser::GetExpectedOpeningBracket
  expect_error "get a ", Mint::Parser::GetExpectedOpeningBracket
  expect_error "get a :", Mint::Parser::GetExpectedType
  expect_error "get a : ", Mint::Parser::GetExpectedType
  expect_error "get a : T", Mint::Parser::GetExpectedOpeningBracket
  expect_error "get a : T ", Mint::Parser::GetExpectedOpeningBracket
  expect_error "get a : T {", Mint::Parser::GetExpectedExpression
  expect_error "get a : T { ", Mint::Parser::GetExpectedExpression
  expect_error "get a : T { a .", Mint::Parser::GetExpectedClosingBracket

  expect_ok "get a { a}"
  expect_ok "get a : T { a}"
  expect_ok "get a : T { a }"
end
