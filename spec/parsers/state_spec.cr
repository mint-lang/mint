require "../spec_helper"

describe "State" do
  subject state

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "state ", Mint::Parser::StateExpectedName
  expect_error "state .", Mint::Parser::StateExpectedName
  expect_error "state  a.", Mint::Parser::StateExpectedEqualSign
  expect_error "state a .", Mint::Parser::StateExpectedEqualSign
  expect_error "state a :", Mint::Parser::StateExpectedType
  expect_error "state a : ", Mint::Parser::StateExpectedType
  expect_error "state a : T", Mint::Parser::StateExpectedEqualSign
  expect_error "state a : T ", Mint::Parser::StateExpectedEqualSign
  expect_error "state a : T =", Mint::Parser::StateExpectedDefaultValue
  expect_error "state a : T = ", Mint::Parser::StateExpectedDefaultValue

  expect_ok "state test : Type = a"
end
