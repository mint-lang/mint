require "../spec_helper"

describe "Connect" do
  subject connect

  expect_ignore "asd"
  expect_ignore "component"
  expect_ignore ".*"

  expect_error "connect ", Mint::Parser::ConnectExpectedType
  expect_error "connect X", Mint::Parser::ConnectExpectedExposing
  expect_error "connect X ", Mint::Parser::ConnectExpectedExposing
  expect_error "connect X exposing", Mint::Parser::ConnectExpectedOpeningBracket
  expect_error "connect X exposing ", Mint::Parser::ConnectExpectedOpeningBracket
  expect_error "connect X exposing {", Mint::Parser::ConnectExpectedKeys
  expect_error "connect X exposing {a", Mint::Parser::ConnectExpectedClosingBracket
  expect_error "connect X exposing {a ", Mint::Parser::ConnectExpectedClosingBracket

  expect_ok "connect X exposing { a }"
  expect_ok "connect X exposing { a, b }"
end
