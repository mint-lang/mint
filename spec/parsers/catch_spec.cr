require "../spec_helper"

describe "Catch" do
  subject catch

  expect_ignore ""
  expect_ignore "ad"
  expect_ignore "???"
  expect_ignore "catc"

  expect_error "catch", Parser::CatchExpectedType
  expect_error "catch ", Parser::CatchExpectedType
  expect_error "catch X", Parser::CatchExpectedArrow
  expect_error "catch X ", Parser::CatchExpectedArrow
  expect_error "catch X =>", Parser::CatchExpectedVariable
  expect_error "catch X => ", Parser::CatchExpectedVariable
  expect_error "catch X => a", Parser::CatchExpectedOpeningBracket
  expect_error "catch X => a ", Parser::CatchExpectedOpeningBracket
  expect_error "catch X => a {", Parser::CatchExpectedExpression
  expect_error "catch X => a {a", Parser::CatchExpectedClosingBracket

  expect_ok "catch X => a { a }"
end
