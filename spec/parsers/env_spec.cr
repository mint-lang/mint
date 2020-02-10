require "../spec_helper"

describe "Env" do
  subject env

  expect_ignore "a"
  expect_ignore "."
  expect_ignore "ge"

  expect_error "@", Mint::Parser::EnvExpectedName
  expect_error "@a", Mint::Parser::EnvExpectedName

  expect_ok "@API_ENDPOINT"
  expect_ok "@ENDPOINT"
  expect_ok "@HOST"
end
