require "../spec_helper"

describe "Finally" do
  subject finally

  expect_ignore ""
  expect_ignore "a"
  expect_ignore "??,"
  expect_ignore "finall"

  expect_error "finally", Mint::Parser::FinallyExpectedOpeningBracket
  expect_error "finally ", Mint::Parser::FinallyExpectedOpeningBracket
  expect_error "finally {", Mint::Parser::FinallyExpectedExpression
  expect_error "finally { ", Mint::Parser::FinallyExpectedExpression
  expect_error "finally { a", Mint::Parser::FinallyExpectedClosingBracket
  expect_error "finally { a ", Mint::Parser::FinallyExpectedClosingBracket

  expect_ok "finally{a}"
  expect_ok "finally { a }"
end
