require "../spec_helper"

describe "Unary Minus" do
  subject unary_minus

  expect_ignore "."
  expect_ignore "-"
  expect_ignore "- "

  expect_ok "-0"
  expect_ok "--20"
  expect_ok "-a"
end
