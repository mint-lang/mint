require "../spec_helper"

describe "Array" do
  subject array

  expect_ignore " "
  expect_ignore "."
  expect_ignore "asd"

  expect_error "[", Mint::Parser::ArrayExpectedClosingBracket
  expect_error "[a", Mint::Parser::ArrayExpectedClosingBracket

  expect_ok "[a,b,c]"
end
