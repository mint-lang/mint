require "../spec_helper"

describe "Interpolation" do
  subject interpolation

  expect_ignore ""
  expect_ignore "??"
  expect_ignore "asd"
  expect_ignore "{"

  expect_error "\#{", Mint::Parser::InterpolationExpectedExpression
  expect_error "\#{ ", Mint::Parser::InterpolationExpectedExpression
  expect_error "\#{a", Mint::Parser::InterpolationExpectedClosingBracket
  expect_error "\#{a  ", Mint::Parser::InterpolationExpectedClosingBracket

  expect_ok "\#{a}"
  expect_ok "\#{ a }"
end
