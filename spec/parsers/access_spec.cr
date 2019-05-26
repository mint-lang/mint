require "../spec_helper"

describe "Access" do
  subject access(Mint::Ast::Record::UNIT)

  expect_error ".", Mint::Parser::AccessExpectedVariable

  expect_ok ".asd"
end
