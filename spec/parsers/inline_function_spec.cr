require "../spec_helper"

describe "Inline Function" do
  subject inline_function

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "(", Mint::Parser::InlineFunctionExpectedClosingParentheses
  expect_error "(a : Event ", Mint::Parser::InlineFunctionExpectedClosingParentheses
  expect_error "(a : Event)", Mint::SyntaxError
  expect_error "(a : Event) :", Mint::Parser::InlineFunctionExpectedType
  expect_error "(a : Event) : X", Mint::SyntaxError
  expect_error "(a : Event) : X {", Mint::SyntaxError
  expect_error "(a : Event) : X { b ", Mint::SyntaxError

  expect_ok "(a : Event) { b }"
  expect_ok "(a : Event) : X { b }"
end
