require "../spec_helper"

describe "Connect" do
  subject connect

  expect_ignore "asd"
  expect_ignore "component"
  expect_ignore ".*"

  expect_error "connect", Parser::ConnectExpectedType
  expect_error "connect ", Parser::ConnectExpectedType
  expect_error "connect X", Parser::ConnectExpectedExposing
  expect_error "connect X ", Parser::ConnectExpectedExposing
  expect_error "connect X exposing", Parser::ConnectExpectedOpeningBracket
  expect_error "connect X exposing ", Parser::ConnectExpectedOpeningBracket
  expect_error "connect X exposing {", Parser::ConnectExpectedKeys
  expect_error "connect X exposing {a", Parser::ConnectExpectedClosingBracket
  expect_error "connect X exposing {a ", Parser::ConnectExpectedClosingBracket

  expect_ok "connect X exposing { a }"
  expect_ok "connect X exposing { a, b }"
end
