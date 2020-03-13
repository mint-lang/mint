require "../spec_helper"

describe "Function Definition" do
  subject function

  expect_ignore ":"

  expect_error "a (", Mint::Parser::FunctionExpectedClosingParentheses
  expect_error "a ( ", Mint::Parser::FunctionExpectedClosingParentheses
  expect_error "a () :", Mint::Parser::FunctionExpectedTypeOrVariable
  expect_error "a () : ", Mint::Parser::FunctionExpectedTypeOrVariable

  expect_ok "a { true } "
  expect_ok "a : T { true } "
  expect_ok "a : x { true } "
  expect_ok "a () : T { false }"
  expect_ok "a ( ) : T { balh }"
end
