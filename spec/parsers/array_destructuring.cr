require "../spec_helper"

describe "Array Destructuring" do
  subject array_destructuring

  expect_ignore "."
  expect_ignore ".."
  expect_ignore "["

  expect_error "[a", Mint::Parser::ArrayDestructuringExpectedClosingBracket
  expect_error "[a,", Mint::Parser::ArrayDestructuringExpectedClosingBracket
  expect_error "[a, b", Mint::Parser::ArrayDestructuringExpectedClosingBracket

  expect_ok "[a]"
  expect_ok "[a,b]"
  expect_ok "[...a,b]"
  expect_ok "[a,b,...c]"
end
