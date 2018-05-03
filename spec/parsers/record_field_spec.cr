require "../spec_helper"

describe "Record Field" do
  subject record_field

  expect_ignore "."
  expect_ignore "-"
  expect_ignore "{"

  expect_error "asd", Mint::Parser::RecordFieldExpectedEqualSign
  expect_error "asd ", Mint::Parser::RecordFieldExpectedEqualSign
  expect_error "asd =", Mint::Parser::RecordFieldExpectedExpression
  expect_error "asd = ", Mint::Parser::RecordFieldExpectedExpression

  expect_ok "asd = asd"
end
