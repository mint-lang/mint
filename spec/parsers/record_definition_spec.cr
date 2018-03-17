require "../spec_helper"

describe "Record Definition" do
  subject record_definition

  expect_ignore "."
  expect_ignore "asd"
  expect_ignore "::"

  expect_error "record", Parser::RecordDefinitionExpectedName
  expect_error "record ", Parser::RecordDefinitionExpectedName
  expect_error "record T.T", Parser::RecordDefinitionExpectedOpeningBracket
  expect_error "record T.T ", Parser::RecordDefinitionExpectedOpeningBracket
  expect_error "record T.T {", Parser::RecordDefinitionExpectedClosingBracket
  expect_error "record T.T { ", Parser::RecordDefinitionExpectedClosingBracket
  expect_error "record T.T { a: T", Parser::RecordDefinitionExpectedClosingBracket

  expect_ok "record T.T { a: T } "
  expect_ok "record T.T { } "
end
