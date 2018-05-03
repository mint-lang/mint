require "../spec_helper"

describe "Record Definition" do
  subject record_definition

  expect_ignore "."
  expect_ignore "asd"
  expect_ignore "::"

  expect_error "record", Mint::Parser::RecordDefinitionExpectedName
  expect_error "record ", Mint::Parser::RecordDefinitionExpectedName
  expect_error "record T.T", Mint::Parser::RecordDefinitionExpectedOpeningBracket
  expect_error "record T.T ", Mint::Parser::RecordDefinitionExpectedOpeningBracket
  expect_error "record T.T {", Mint::Parser::RecordDefinitionExpectedClosingBracket
  expect_error "record T.T { ", Mint::Parser::RecordDefinitionExpectedClosingBracket
  expect_error "record T.T { a: T", Mint::Parser::RecordDefinitionExpectedClosingBracket

  expect_ok "record T.T { a: T } "
  expect_ok "record T.T { } "
end
