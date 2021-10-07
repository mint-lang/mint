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
  expect_error "catch X => a", Mint::SyntaxError
  expect_error "catch X => a ", Mint::SyntaxError
  expect_error "catch X => a {", Mint::SyntaxError
  expect_error "catch X => a {a", Mint::SyntaxError

  expect_ok "catch X => a { a }"
end
