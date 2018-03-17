require "../spec_helper"

describe "Record Definition Field" do
  subject record_definition_field

  expect_ignore ":"
  expect_ignore "-asd"
  expect_ignore "???"

  expect_error "asd", Parser::RecordDefinitionFieldExpectedColon
  expect_error "asd:", Parser::RecordDefinitionFieldExpectedType
  expect_error "asd: ", Parser::RecordDefinitionFieldExpectedType

  expect_ok "asd: T"
  expect_ok "asd : T"
  expect_ok "asd: T(Number)"
end
