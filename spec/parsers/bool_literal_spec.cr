require "../spec_helper"

describe "Bool Literal" do
  subject bool_literal

  expect_ignore "a"
  expect_ignore "."
  expect_ignore "blah"

  expect_ok "true"
  expect_ok "false"
end
