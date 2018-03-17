require "../spec_helper"

describe "Css Selectors" do
  subject css_selector

  expect_error "&v", Parser::CssSelectorSpaceAfterAmpersand
  expect_error "& ", Parser::CssSelectorExpectedName
  expect_error "& v", Parser::CssSelectorExpectedOpeningBracket
  expect_error "& v ", Parser::CssSelectorExpectedOpeningBracket
  expect_error "& v {", Parser::CssSelectorExpectedClosingBracket
  expect_error "& v { ", Parser::CssSelectorExpectedClosingBracket
  expect_error "& v { a: b;", Parser::CssSelectorExpectedClosingBracket

  expect_ok "& valami { }"
  expect_ok "& valami { a: b; }"
end
