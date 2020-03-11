require "../spec_helper"

describe "Tuple Destructuring" do
  subject tuple_destructuring

  expect_ignore ""
  expect_ignore "??"
  expect_ignore "✔"
  expect_ignore "a"
  expect_ignore "a "

  expect_error "{a ", Mint::SyntaxError

  expect_ok "{a, b, c}"
  expect_ok "{a, b, c, d}"
end
