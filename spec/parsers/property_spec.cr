require "../spec_helper"

describe "Component Property" do
  subject property

  expect_ignore "prop"
  expect_ignore "asd"

  expect_error "property", Parser::PropertyExpectedName
  expect_error "property ", Parser::PropertyExpectedName
  expect_error "property .", Parser::PropertyExpectedName
  expect_error "property  a.", Parser::PropertyExpectedColon
  expect_error "property a .", Parser::PropertyExpectedColon
  expect_error "property a :", Parser::PropertyExpectedType
  expect_error "property a : ", Parser::PropertyExpectedType
  expect_error "property a : T", Parser::PropertyExpectedEqualSign
  expect_error "property a : T ", Parser::PropertyExpectedEqualSign
  expect_error "property a : T =", Parser::PropertyExpectedDefaultValue
  expect_error "property a : T = ", Parser::PropertyExpectedDefaultValue

  expect_ok "property test : Type = a"
end
