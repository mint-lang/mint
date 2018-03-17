require "../spec_helper"

describe "Component Style" do
  subject style

  expect_ignore "asd"
  expect_ignore "."
  expect_ignore ":"

  expect_error "style", Parser::StyleExpectedName
  expect_error "style ", Parser::StyleExpectedName
  expect_error "style .", Parser::StyleExpectedName
  expect_error "style T", Parser::StyleExpectedName
  expect_error "style t", Parser::StyleExpectedOpeningBracket
  expect_error "style t {", Parser::StyleExpectedClosingBracket
  expect_error "style t { a: b;", Parser::StyleExpectedClosingBracket
  expect_error "style t { a: b; ", Parser::StyleExpectedClosingBracket

  expect_ok "style t { a: b; }"
end
