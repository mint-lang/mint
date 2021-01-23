require "../../spec_helper"

describe "Format Directive" do
  subject format_directive

  expect_ignore "?"
  expect_ignore "."
  expect_ignore "@form"

  expect_error "@format", Mint::Parser::FormatDirectiveExpectedOpeningBracket
  expect_error "@format {", Mint::Parser::FormatDirectiveExpectedExpression
  expect_error "@format {a", Mint::Parser::FormatDirectiveExpectedClosingBracket

  expect_ok "@format{a}"
  expect_ok "@format { a }"
end
