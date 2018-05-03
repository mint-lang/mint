require "../spec_helper"

describe "Module Call" do
  subject module_call

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "Test"
  expect_ignore "asd"

  expect_error "T.", Mint::Parser::ModuleCallExpectedFunction
  expect_error "T.?", Mint::Parser::ModuleCallExpectedFunction
  expect_error "T.something(", Mint::Parser::ModuleCallExpectedClosingParentheses

  expect_ok "Test.blah()"
  expect_ok "Ui.Test.blah()"
  expect_ok "Ui.Test.blah(true, false)"
  expect_ok "Ui.Test.blah( true, false )"
  expect_ok "Ui.Test.blah(true,false)"
end
