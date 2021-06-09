require "../spec_helper"

describe "Statement" do
  subject statement(:try)

  expect_ignore ""
  expect_ignore "??"
  expect_ignore "✔"
  expect_ignore "a ="
  expect_ignore "a = "

  expect_ok "a = a"
  expect_ok "{a, b, c} = a"
end
