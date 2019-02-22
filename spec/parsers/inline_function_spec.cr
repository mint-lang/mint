require "../spec_helper"

describe "Inline Function" do
  subject inline_function

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "(", Mint::Parser::InlineFunctionExpectedClosingParentheses
  expect_error "(a : Event ", Mint::Parser::InlineFunctionExpectedClosingParentheses
  expect_error "(a : Event)", Mint::Parser::InlineFunctionExpectedColon
  expect_error "(a : Event) :", Mint::Parser::InlineFunctionExpectedType
  expect_error "(a : Event) : X", Mint::Parser::InlineFunctionExpectedOpeningBracket
  expect_error "(a : Event) : X {", Mint::Parser::InlineFunctionExpectedExpression
  expect_error "(a : Event) : X { b ", Mint::Parser::InlineFunctionExpectedClosingBracket

  expect_ok "(a : Event) : X { b }"
end
