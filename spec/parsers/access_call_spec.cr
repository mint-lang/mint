require "../spec_helper"

describe "Access" do
  subject access_call

  expect_ignore "."
  expect_ignore "asd"
  expect_ignore "asd.asd"

  expect_error "asd.", Mint::Parser::AccessExpectedVariable
  expect_error "asd.asd(", Mint::Parser::AccessCallExpectedClosingParentheses

  expect_ok "asd.asd()"
  expect_ok "asd.asd(asd, asd)"
end
