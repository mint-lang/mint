require "../spec_helper"

describe "Function Call" do
  subject function_call

  expect_ignore "asd"
  expect_ignore "."
  expect_ignore "blah."
  expect_ignore "Module"

  expect_error "asd(", Parser::FunctionCallExpectedClosingParentheses
  expect_error "asd(asd,xxx", Parser::FunctionCallExpectedClosingParentheses

  expect_ok "asdf(test, true)"
  expect_ok "asdf( test,true )"
end
