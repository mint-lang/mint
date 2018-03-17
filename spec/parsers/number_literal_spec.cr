require "../spec_helper"

describe "Number Literal" do
  subject number_literal

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "0.", Parser::NumberLiteralExpectedDecimal

  expect_ok "0"
  expect_ok "0.0"
  expect_ok "-10.0"
end
