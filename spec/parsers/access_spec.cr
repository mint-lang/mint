require "../spec_helper"

describe "Access" do
  subject access

  expect_ignore "."
  expect_ignore "asd"

  expect_error "asd.", Mint::Parser::AccessExpectedVariable

  expect_ok "asd.asd"
end
