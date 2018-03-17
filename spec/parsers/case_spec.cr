require "../spec_helper"

describe "Case Expression" do
  subject case_expression

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "case", Parser::CaseExpectedOpeningParentheses
  expect_error "case ", Parser::CaseExpectedOpeningParentheses
  expect_error "case (", Parser::CaseExpectedCondition
  expect_error "case (a", Parser::CaseExpectedClosingParentheses
  expect_error "case (a)", Parser::CaseExpectedOpeningBracket
  expect_error "case (a) ", Parser::CaseExpectedOpeningBracket
  expect_error "case (a) {", Parser::CaseExpectedBranches
  expect_error "case (a) { ", Parser::CaseExpectedBranches
  expect_error "case (a) { a => b", Parser::CaseExpectedClosingBracket

  expect_ok "case (a) { a => b }"
  expect_ok "case (a) { a => b b => a }"
  expect_ok "case (a) { a => T.blah()b => a }"
end
