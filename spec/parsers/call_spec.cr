require "../spec_helper"

describe "Call" do
  subject call(Mint::Ast::Record::UNIT)

  expect_error "(", Mint::Parser::CallExpectedClosingParentheses

  expect_ok "(asd, asd)"
end
