require "../spec_helper"

describe "Statement" do
  subject statement

  expect_ignore ""
  expect_ignore "??"
  expect_ignore "✔"

  expect_ok "let a = a"
  expect_ok "let {a, b, c} = a"
end
