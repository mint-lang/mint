require "../spec_helper"

describe "Record" do
  subject record

  expect_ignore ","
  expect_ignore "-lsa"
  expect_ignore "asd"

  expect_ignore "{"
  expect_ignore "{ "
  expect_ignore "{ a: a"
  expect_ignore "{ a: a "

  expect_ok "{}"
  expect_ok "{ }"
  expect_ok "{ a: a }"
end
