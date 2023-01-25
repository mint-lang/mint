require "../spec_helper"

describe "Record Field" do
  subject record_field

  expect_ignore "."
  expect_ignore "-"
  expect_ignore "{"

  expect_ignore "asd"
  expect_ignore "asd "
  expect_ignore "asd:"
  expect_ignore "asd: "

  expect_ok "asd: asd"
end
