require "../spec_helper"

describe "Case Expression" do
  subject case_expression

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "case", Mint::Parser::CaseExpectedOpeningParentheses
  expect_error "case ", Mint::Parser::CaseExpectedOpeningParentheses
  expect_error "case (", Mint::Parser::CaseExpectedCondition
  expect_error "case (a", Mint::Parser::CaseExpectedClosingParentheses
  expect_error "case (a)", Mint::Parser::CaseExpectedOpeningBracket
  expect_error "case (a) ", Mint::Parser::CaseExpectedOpeningBracket
  expect_error "case (a) {", Mint::Parser::CaseExpectedBranches
  expect_error "case (a) { ", Mint::Parser::CaseExpectedBranches
  expect_error "case (a) { a => b", Mint::Parser::CaseExpectedClosingBracket

  expect_ok "case (a) { a => b }"
  expect_ok "case (a) { a => b b => a }"
  expect_ok "case (a) { a => T.blah()b => a }"
  expect_ok "case (a) { [] => try { a } [head, ...tail] => { try { a } } }"
end
