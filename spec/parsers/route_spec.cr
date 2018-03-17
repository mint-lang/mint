require "../spec_helper"

describe "Route" do
  subject route

  expect_ignore ""
  expect_ignore ".."
  expect_ignore "a"
  expect_ignore "asdasd"

  expect_error "*asd", Parser::RouteExpectedOpeningBracket
  expect_error "/test", Parser::RouteExpectedOpeningBracket
  expect_error "/test (a:String", Parser::RouteExpectedClosingParentheses
  expect_error "/test (a:String)", Parser::RouteExpectedOpeningBracket
  expect_error "/test (a:String){", Parser::RouteExpectedExpression
  expect_error "/test (a:String){ void ", Parser::RouteExpectedClosingBracket

  expect_ok "/ { void }"
  expect_ok "* { void }"
  expect_ok "/asd { void }"
  expect_ok "/asd (a : String) { void }"
end
