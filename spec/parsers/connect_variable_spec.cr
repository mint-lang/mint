require "../spec_helper"

describe "ConnectVariable" do
  subject connect_variable

  expect_ignore ".*"

  expect_error "x as", Mint::Parser::ConnectVariableExpectedAs

  expect_ok "x"
  expect_ok "x as y"
end
