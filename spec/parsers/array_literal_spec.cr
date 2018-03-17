require "../spec_helper"

describe "Access" do
  subject array

  expect_ignore " "
  expect_ignore "."
  expect_ignore "asd"

  expect_error "[", Parser::ArrayExpectedClosingBracket
  expect_error "[a", Parser::ArrayExpectedClosingBracket

  expect_ok "[a,b,c]"
end
