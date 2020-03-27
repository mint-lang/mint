require "../spec_helper"

describe "Store" do
  subject store

  expect_ignore "."
  expect_ignore "asd"
  expect_ignore "blah"

  expect_error "store", Mint::Parser::StoreExpectedName
  expect_error "store ", Mint::Parser::StoreExpectedName
  expect_error "store T", Mint::Parser::StoreExpectedOpeningBracket
  expect_error "store T ", Mint::Parser::StoreExpectedOpeningBracket
  expect_error "store T {", Mint::Parser::StoreExpectedBody
  expect_error "store T { ", Mint::Parser::StoreExpectedBody
  expect_error "store T { state a : T = a", Mint::Parser::StoreExpectedClosingBracket
  expect_error "store T { state a : T = a ", Mint::Parser::StoreExpectedClosingBracket
  expect_error "store T { state a : T = 0state b : T = 1", Mint::Parser::StoreExpectedClosingBracket

  expect_ok "store T { state a : T = a }"
end
