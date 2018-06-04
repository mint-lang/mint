require "../spec_helper"

describe "Array access" do
  subject array_access

  expect_ignore " "
  expect_ignore "."
  expect_ignore "asd"

  expect_error "[1][", Mint::Parser::ArrayAccessExpectedIndex
  expect_error "[1][1", Mint::Parser::ArrayAccessExpectedClosingBracket
  expect_error "[1][]", Mint::Parser::ArrayAccessExpectedIndex

  expect_ok "[1][1]"
  expect_ok "[1,2][ 1 ]"
end
