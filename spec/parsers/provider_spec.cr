require "../spec_helper"

describe "Provider" do
  subject provider

  expect_ignore ""
  expect_ignore "."
  expect_ignore "prov"

  expect_error "provider", Mint::Parser::ProviderExpectedName
  expect_error "provider Test", Mint::Parser::ProviderExpectedColon
  expect_error "provider Test: ", Mint::Parser::ProviderExpectedSubscription
  expect_error "provider Test:TestSub", Mint::Parser::ProviderExpectedOpeningBracket
  expect_error "provider Test:TestSub {", Mint::Parser::ProviderExpectedBody
  expect_error "provider Test:TestSub { fun test : Void {void}", Mint::Parser::ProviderExpectedClosingBracket

  expect_ok "provider Test:TestSub { fun test : Void {void} }"
end
