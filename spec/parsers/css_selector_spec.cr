require "../spec_helper"

describe "Css Selectors" do
  subject css_selector

  expect_error "&v", Mint::Parser::CssSelectorSpaceAfterAmpersand
  expect_error "& ", Mint::Parser::CssSelectorExpectedName
  expect_error "& v", Mint::Parser::CssSelectorExpectedOpeningBracket
  expect_error "& v ", Mint::Parser::CssSelectorExpectedOpeningBracket
  expect_error "& v {", Mint::Parser::CssSelectorExpectedClosingBracket
  expect_error "& v { ", Mint::Parser::CssSelectorExpectedClosingBracket
  expect_error "& v { a: b;", Mint::Parser::CssSelectorExpectedClosingBracket

  expect_ok "& valami { }"
  expect_ok "& valami { a: b; }"
end
