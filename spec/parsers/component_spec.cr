require "../spec_helper"

describe "Component Definition" do
  subject component

  expect_ignore "comp"
  expect_ignore "asd"

  expect_error "component", Mint::Parser::ComponentExpectedName
  expect_error "component{", Mint::Parser::ComponentExpectedName
  expect_error "component ", Mint::Parser::ComponentExpectedName
  expect_error "component a", Mint::Parser::ComponentExpectedName
  expect_error "component T", Mint::Parser::ComponentExpectedOpeningBracket
  expect_error "component T ", Mint::Parser::ComponentExpectedOpeningBracket
  expect_error "component T {", Mint::Parser::ComponentExpectedBody
  expect_error "component T { ", Mint::Parser::ComponentExpectedBody
  expect_error "component T.", Mint::Parser::ComponentExpectedName
  expect_error "component T.T { property a : T = a", Mint::Parser::ComponentExpectedClosingBracket

  expect_ok "component T { get a : T { a } }"
  expect_ok "component T { property a : T = b }"
  expect_ok "component T.T { property a : T = a }"
  expect_ok "component T.T { property a : T = a}"
  expect_ok "component T { style test { a: b; } }"
  expect_ok "component T { connect B exposing { a } }"
  expect_ok "component T { style test { a: b; }style a { a: b; } }"
end
