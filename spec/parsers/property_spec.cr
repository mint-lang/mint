require "../spec_helper"

describe "Component Property" do
  subject property

  expect_ignore "prop"
  expect_ignore "asd"

  expect_error "property ", Mint::Parser::PropertyExpectedName
  expect_error "property .", Mint::Parser::PropertyExpectedName
  expect_error "property a :", Mint::Parser::PropertyExpectedType
  expect_error "property a : ", Mint::Parser::PropertyExpectedType
  expect_error "property a : T =", Mint::Parser::PropertyExpectedDefaultValue
  expect_error "property a : T = ", Mint::Parser::PropertyExpectedDefaultValue

  expect_ok "property a : T"
  expect_ok "property test = a"
  expect_ok "property test : Type = a"
end
