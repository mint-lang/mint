require "../spec_helper"

describe "Provider" do
  subject provider

  expect_ignore ""
  expect_ignore "."
  expect_ignore "prov"

  expect_error "provider", Parser::ProviderExpectedName
  expect_error "provider Test", Parser::ProviderExpectedColon
  expect_error "provider Test: ", Parser::ProviderExpectedSubscription
  expect_error "provider Test:TestSub", Parser::ProviderExpectedOpeningBracket
  expect_error "provider Test:TestSub {", Parser::ProviderExpectedBody
  expect_error "provider Test:TestSub { fun test : Void {void}", Parser::ProviderExpectedClosingBracket

  expect_ok "provider Test:TestSub { fun test : Void {void} }"
end
