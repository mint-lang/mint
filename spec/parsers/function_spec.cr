require "../spec_helper"

describe "Function Definition" do
  subject function

  expect_ignore ":"
  expect_ignore "a"
  expect_ignore "fu"

  expect_error "fun", Mint::Parser::FunctionExpectedName
  expect_error "fun ", Mint::Parser::FunctionExpectedName
  expect_error "fun a", Mint::Parser::FunctionExpectedOpeningBracket
  expect_error "fun a ", Mint::Parser::FunctionExpectedOpeningBracket
  expect_error "fun a (", Mint::Parser::FunctionExpectedClosingParentheses
  expect_error "fun a ( ", Mint::Parser::FunctionExpectedClosingParentheses
  expect_error "fun a ()", Mint::Parser::FunctionExpectedOpeningBracket
  expect_error "fun a () ", Mint::Parser::FunctionExpectedOpeningBracket
  expect_error "fun a () :", Mint::Parser::FunctionExpectedTypeOrVariable
  expect_error "fun a () : ", Mint::Parser::FunctionExpectedTypeOrVariable

  expect_ok "fun a { true } "
  expect_ok "fun a : T { true } "
  expect_ok "fun a : x { true } "
  expect_ok "fun a () : T { false }"
  expect_ok "fun a ( ) : T { balh }"
end
