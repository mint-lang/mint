require "../spec_helper"

describe "Variable" do
  subject type_variable

  expect_ignore " "
  expect_ignore "."
  expect_ignore "???"

  expect_ok "a"
  expect_ok "asd"
  expect_ok "asdAsd"
  expect_ok "asd_"
end
