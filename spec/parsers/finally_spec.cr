require "../spec_helper"

describe "Finally" do
  subject finally

  expect_ignore ""
  expect_ignore "a"
  expect_ignore "??,"
  expect_ignore "finall"

  expect_error "finally", Parser::FinallyExpectedOpeningBracket
  expect_error "finally ", Parser::FinallyExpectedOpeningBracket
  expect_error "finally {", Parser::FinallyExpectedExpression
  expect_error "finally { ", Parser::FinallyExpectedExpression
  expect_error "finally { a", Parser::FinallyExpectedClosingBracket
  expect_error "finally { a ", Parser::FinallyExpectedClosingBracket

  expect_ok "finally{a}"
  expect_ok "finally { a }"
end
