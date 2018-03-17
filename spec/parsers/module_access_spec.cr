require "../spec_helper"

describe "Module Call" do
  subject module_access

  expect_ignore " "
  expect_ignore "."
  expect_ignore "a"
  expect_ignore "???"
  expect_ignore "Asd"
  expect_ignore "Asd.Asd"

  expect_error "Asd.", Parser::ModuleAccessExpectedFunction

  expect_ok "Asd.asd"
end
