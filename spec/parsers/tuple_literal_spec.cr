require "../spec_helper"

describe "Tuple" do
  subject tuple_literal

  expect_ignore " "
  expect_ignore "."
  expect_ignore "asd"

  expect_ignore "{"
  expect_ignore "{a"
  expect_ignore "{a,"
  expect_ignore "{a,b"
  expect_ignore "{a,{b}"

  expect_ok "{}"
  expect_ok "{a,b,c}"
  expect_ok "{a,{b},c}"
end
