require "../spec_helper"

describe "Type" do
  subject type

  expect_ignore ":"
  expect_ignore "a"

  expect_error "T(a, T.)", Mint::Parser::TypeExpectedType
  expect_error "T(", Mint::Parser::TypeExpectedTypeOrVariable
  expect_error "T(T", Mint::Parser::TypeExpectedClosingParentheses

  expect_ok "T"
  expect_ok "Type01Blank"
  expect_ok "T()"
  expect_ok "T(T)"
  expect_ok "T(T,T)"
  expect_ok "T(T, T, T)"
  expect_ok "T(T, T, T(T))"
  expect_ok "T(T, T, T(T, X(Y)))"
end

describe "Type!" do
  subject type!(Mint::SyntaxError)

  expect_error "a", Mint::SyntaxError

  expect_ok "T"
end
