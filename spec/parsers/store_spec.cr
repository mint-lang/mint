require "../spec_helper"

describe "Store" do
  subject store

  expect_ignore "."
  expect_ignore "asd"
  expect_ignore "blah"

  expect_error "store", Parser::StoreExpectedName
  expect_error "store ", Parser::StoreExpectedName
  expect_error "store T", Parser::StoreExpectedOpeningBracket
  expect_error "store T ", Parser::StoreExpectedOpeningBracket
  expect_error "store T {", Parser::StoreExpectedBody
  expect_error "store T { ", Parser::StoreExpectedBody
  expect_error "store T { property a : T = a", Parser::StoreExpectedClosingBracket
  expect_error "store T { property a : T = a ", Parser::StoreExpectedClosingBracket
  expect_error "store T { property a : T = 0property b : T = 1", Parser::StoreExpectedClosingBracket

  expect_ok "store T { property a : T = a }"
end
