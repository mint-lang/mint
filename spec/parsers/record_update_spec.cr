require "../spec_helper"

describe "Record Update" do
  subject record_update

  expect_ignore "{"
  expect_ignore "..."
  expect_ignore "{ "
  expect_ignore "a"
  expect_ignore "{ asdasd"

  expect_error "{ request |", Mint::Parser::RecordUpdateExpectedFields
  expect_error "{ request | }", Mint::Parser::RecordUpdateExpectedFields
  expect_error "{ request | a: x", Mint::Parser::RecordUpdateExpectedClosingBracket
  expect_error "{ request | a: x ", Mint::Parser::RecordUpdateExpectedClosingBracket

  expect_ok "{request|body:value}"
  expect_ok "{ request | body: value }"
end
