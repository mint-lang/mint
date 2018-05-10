require "../spec_helper"

describe "Next Call" do
  subject next_call

  expect_ignore "{"
  expect_ignore "asd"
  expect_ignore "next"

  expect_error "next ", Mint::Parser::NextCallExpectedRecord

  expect_ok "next {}"
end
