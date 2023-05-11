require "../spec_helper"

describe "Return Call" do
  subject return_call

  expect_ignore "{"
  expect_ignore "asd"
  expect_ignore "return"

  expect_error "return ", Mint::Parser::ReturnCallExpectedExpression

  expect_ok "return a"
end
