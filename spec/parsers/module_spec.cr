require "../spec_helper"

describe "Module" do
  subject module_definition

  expect_ignore "."
  expect_ignore "a"
  expect_ignore "::"
  expect_ignore "mod"
  expect_ignore "modul"

  expect_error "module", Mint::Parser::ModuleExpectedName
  expect_error "module ", Mint::Parser::ModuleExpectedName
  expect_error "module ,", Mint::Parser::ModuleExpectedName
  expect_error "module a", Mint::Parser::ModuleExpectedName
  expect_error "module Test", Mint::Parser::ModuleExpectedOpeningBracket
  expect_error "module Test ", Mint::Parser::ModuleExpectedOpeningBracket
  expect_error "module Test {", Mint::Parser::ModuleExpectedClosingBracket
  expect_error "module Test { ", Mint::Parser::ModuleExpectedClosingBracket
  expect_error "module Test { a : Test { blah }", Mint::Parser::ModuleExpectedClosingBracket

  expect_ok "module Test { }"
end
