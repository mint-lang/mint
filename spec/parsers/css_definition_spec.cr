require "../spec_helper"

describe "Css Definition" do
  subject css_definition

  expect_ignore "."
  expect_ignore "A"
  expect_ignore ":"

  expect_error "a", Parser::CssDefinitionExpectedColon
  expect_error "a:", Parser::CssDefinitionExpectedSemicolon
  expect_error "a: b", Parser::CssDefinitionExpectedSemicolon
  expect_error "a: {", Parser::CssInterpolationExpectedExpression
  expect_error "a: {a", Parser::CssInterpolationExpectedClosingBracket

  expect_ok "a: {a};"
  expect_ok "a: x {a} v;"
  expect_ok "a: x {a} v {a};"
  expect_ok "a: x {a}{a};"
  expect_ok "a: b;"
  expect_ok "-WebKit-Box: 0 red;"
  expect_ok "-webit-box-shadow: 0 0 20px black;"
end
