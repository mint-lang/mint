require "../spec_helper"

describe "Module" do
  subject module_definition

  expect_ignore "."
  expect_ignore "a"
  expect_ignore "::"
  expect_ignore "mod"
  expect_ignore "modul"

  expect_error "module", Parser::ModuleExpectedName
  expect_error "module ", Parser::ModuleExpectedName
  expect_error "module ,", Parser::ModuleExpectedName
  expect_error "module a", Parser::ModuleExpectedName
  expect_error "module Test", Parser::ModuleExpectedOpeningBracket
  expect_error "module Test ", Parser::ModuleExpectedOpeningBracket
  expect_error "module Test {", Parser::ModuleExpectedClosingBracket
  expect_error "module Test { ", Parser::ModuleExpectedClosingBracket
  expect_error "module Test { fun a : Test { blah }", Parser::ModuleExpectedClosingBracket

  expect_ok "module Test { }"
end
