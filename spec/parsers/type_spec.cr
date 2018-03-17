require "../spec_helper"

describe "Type" do
  subject type

  expect_ignore ":"
  expect_ignore "a"

  expect_error "T(a, T.)", Parser::TypeExpectedType
  expect_error "T(", Parser::TypeExpectedTypeOrVariable
  expect_error "T(T", Parser::TypeExpectedClosingParentheses

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
  subject type!(SyntaxError)

  expect_error "a", SyntaxError

  expect_ok "T"
end
