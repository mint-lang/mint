require "../spec_helper"

describe "Css Interpolation" do
  subject css_interpolation

  expect_ignore ""
  expect_ignore "??"
  expect_ignore "asd"

  expect_error "{", Parser::CssInterpolationExpectedExpression
  expect_error "{ ", Parser::CssInterpolationExpectedExpression
  expect_error "{a", Parser::CssInterpolationExpectedClosingBracket
  expect_error "{a  ", Parser::CssInterpolationExpectedClosingBracket

  expect_ok "{a}"
  expect_ok "{ a }"
end
