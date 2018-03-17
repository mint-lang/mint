require "../spec_helper"

describe "Inline Function" do
  subject inline_function

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "\\", Parser::InlineFunctionExpectedArrow
  expect_error "\\a : Event ", Parser::InlineFunctionExpectedArrow
  expect_error "\\a : Event =>", Parser::InlineFunctionExpectedExpression
  expect_error "\\a : Event => ", Parser::InlineFunctionExpectedExpression

  expect_ok "\\a : Event => b"
end
