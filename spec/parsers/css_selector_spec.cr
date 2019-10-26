require "../spec_helper"

describe "Css Selectors" do
  subject css_selector

  expect_error "v {", Mint::Parser::CssSelectorExpectedClosingBracket
  expect_error "v { ", Mint::Parser::CssSelectorExpectedClosingBracket
  expect_error "v { a: b;", Mint::Parser::CssSelectorExpectedClosingBracket

  expect_ok "valami { }"
  expect_ok "valami { a: b; }"
end
