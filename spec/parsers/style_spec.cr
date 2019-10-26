require "../spec_helper"

describe "Component Style" do
  subject style

  expect_ignore "asd"
  expect_ignore "."
  expect_ignore ":"

  expect_error "style", Mint::Parser::StyleExpectedName
  expect_error "style ", Mint::Parser::StyleExpectedName
  expect_error "style .", Mint::Parser::StyleExpectedName
  expect_error "style T", Mint::Parser::StyleExpectedName
  expect_error "style t", Mint::Parser::StyleExpectedOpeningBracket
  expect_error "style t {", Mint::Parser::StyleExpectedClosingBracket
  expect_error "style t { a: b;", Mint::Parser::StyleExpectedClosingBracket
  expect_error "style t { a: b; ", Mint::Parser::StyleExpectedClosingBracket
  expect_error "style t (name : String", Mint::Parser::StyleExpectedClosingParentheses

  expect_ok "style t { a: b; }"
  expect_ok "style t (name : String) { a: name; }"
end
