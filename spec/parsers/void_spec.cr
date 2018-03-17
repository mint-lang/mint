require "../spec_helper"

describe "Void" do
  subject void

  expect_ignore ""
  expect_ignore "asd"
  expect_ignore "voi"

  expect_ok "void"
end
