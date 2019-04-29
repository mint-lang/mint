require "../spec_helper"

describe "MemberAccess" do
  subject member_access

  expect_ignore "asd"

  expect_error ".", Mint::Parser::MemberAccessExpectedVariable

  expect_ok ".asd"
end
