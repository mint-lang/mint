require "../spec_helper"

describe "Negated Expression" do
  subject negated_expression

  expect_error "!", Mint::Parser::NegatedExpressionExpectedExpression

  expect_ok "!a"
  expect_ok "!true"
  expect_ok "!false"
  expect_ok "!!true"
  expect_ok "!!false"
  expect_ok "!(a)"
  expect_ok "!(!a)"
end
