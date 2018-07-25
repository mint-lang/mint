require "../spec_helper"

describe "Record Definition Field" do
  subject record_definition_field

  expect_ignore ":"
  expect_ignore "-asd"
  expect_ignore "???"

  expect_error "asd", Mint::Parser::RecordDefinitionFieldExpectedColon
  expect_error "asd:", Mint::Parser::RecordDefinitionFieldExpectedType
  expect_error "asd: ", Mint::Parser::RecordDefinitionFieldExpectedType
  expect_error "asd: T using", Mint::Parser::RecordDefinitionFieldExpectedMapping

  expect_ok "asd: T"
  expect_ok "asd : T"
  expect_ok "asd: T(Number)"
  expect_ok "asd: T(Number) using \"wtf\""
end
