require "../spec_helper"

describe "Catch" do
  subject catch

  expect_ignore ""
  expect_ignore "ad"
  expect_ignore "???"
  expect_ignore "catc"
  expect_ignore "catch"
  expect_ignore "catch "

  expect_error "catch X", Mint::Parser::CatchExpectedArrow
  expect_error "catch X ", Mint::Parser::CatchExpectedArrow
  expect_error "catch X =>", Mint::Parser::CatchExpectedVariable
  expect_error "catch X => ", Mint::Parser::CatchExpectedVariable
  expect_error "catch X => a", Mint::Parser::CatchExpectedOpeningBracket
  expect_error "catch X => a ", Mint::Parser::CatchExpectedOpeningBracket
  expect_error "catch X => a {", Mint::Parser::CatchExpectedExpression
  expect_error "catch X => a {a", Mint::Parser::CatchExpectedClosingBracket

  expect_ok "catch X => a { a }"
end
