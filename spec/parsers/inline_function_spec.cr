require "../spec_helper"

describe "Inline Function" do
  subject inline_function

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "(", Mint::Parser::InlineFunctionExpectedClosingParentheses
  expect_error "(a : Event ", Mint::Parser::InlineFunctionExpectedClosingParentheses
  expect_error "(a : Event)", Mint::Parser::InlineFunctionExpectedArrow
  expect_error "(a : Event) =>", Mint::Parser::InlineFunctionExpectedOpeningBracket
  expect_error "(a : Event) => {", Mint::Parser::InlineFunctionExpectedExpression
  expect_error "(a : Event) => { b ", Mint::Parser::InlineFunctionExpectedClosingBracket

  expect_ok "(a : Event) => { b }"
end
