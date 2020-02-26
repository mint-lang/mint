require "../spec_helper"

describe "Spread" do
  subject spread

  expect_ignore "."
  expect_ignore ".."
  expect_ignore "asd"

  expect_error "...", Mint::Parser::SpreadExpectedVariable

  expect_ok "...asd"
end
