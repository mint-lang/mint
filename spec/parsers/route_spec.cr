require "../spec_helper"

describe "Route" do
  subject route

  expect_ignore ""
  expect_ignore ".."
  expect_ignore "a"
  expect_ignore "asdasd"

  expect_error "*asd", Mint::Parser::RouteExpectedOpeningBracket
  expect_error "/test", Mint::Parser::RouteExpectedOpeningBracket
  expect_error "/test (a:String", Mint::Parser::RouteExpectedClosingParentheses
  expect_error "/test (a:String)", Mint::Parser::RouteExpectedOpeningBracket
  expect_error "/test (a:String){", Mint::Parser::RouteExpectedExpression
  expect_error "/test (a:String){ void ", Mint::Parser::RouteExpectedClosingBracket

  expect_ok "/ { void }"
  expect_ok "* { void }"
  expect_ok "/asd { void }"
  expect_ok "/asd (a : String) { void }"
end
