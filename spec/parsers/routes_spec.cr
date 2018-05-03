require "../spec_helper"

describe "Route" do
  subject routes

  expect_ignore ""
  expect_ignore ".."
  expect_ignore "a"
  expect_ignore "asdasd"

  expect_error "routes", Mint::Parser::RoutesExpectedOpeningBracket
  expect_error "routes{", Mint::Parser::RoutesExpectedRoute
  expect_error "routes{ /test{void}", Mint::Parser::RoutesExpectedClosingBracket

  expect_ok "routes{ /test{void} }"
end
