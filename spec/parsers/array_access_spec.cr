require "../spec_helper"

describe "Array access" do
  subject array_access(Mint::Ast::Record::UNIT)

  expect_error "[", Mint::Parser::ArrayAccessExpectedIndex
  expect_error "[1", Mint::Parser::ArrayAccessExpectedClosingBracket
  expect_error "[]", Mint::Parser::ArrayAccessExpectedIndex

  expect_ok "[1]"
  expect_ok "[1][ 1 ]"
end
