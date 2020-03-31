require "../spec_helper"

describe "Css Keyframes" do
  subject css_keyframes

  expect_error "@keyframes", Mint::Parser::CssKeyframesExpectedName
  expect_error "@kayframes test ", Mint::Parser::CssKeyframesExpectedOpeningBracket
  expect_error "@keyframes test {", Mint::Parser::CssKeyframesExpectedClosingBracket

  expect_ok "@keyframes test { }"
  expect_ok "@keyframes test { 0% { a: b; } }"
end
