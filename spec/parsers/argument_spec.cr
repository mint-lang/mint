require "../spec_helper"

describe "Argument" do
  subject argument

  expect_ignore "?"
  expect_ignore "."

  expect_error "asd", Mint::Parser::ArgumentExpectedColon
  expect_error "asd ", Mint::Parser::ArgumentExpectedColon
  expect_error "asd :", Mint::Parser::ArgumentExpectedTypeOrVariable
  expect_error "asd : ", Mint::Parser::ArgumentExpectedTypeOrVariable

  expect_ok "asd : T"
  expect_ok "asd : x"
  expect_ok "asd:Z"
end
