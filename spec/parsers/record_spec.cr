require "../spec_helper"

describe "Record" do
  subject record

  expect_ignore ","
  expect_ignore "-lsa"
  expect_ignore "asd"

  expect_error "{", Parser::RecordExpectedClosingBracket
  expect_error "{ ", Parser::RecordExpectedClosingBracket
  expect_error "{ a = a", Parser::RecordExpectedClosingBracket
  expect_error "{ a = a ", Parser::RecordExpectedClosingBracket

  expect_ok "{}"
  expect_ok "{ }"
  expect_ok "{ a = a }"
end
