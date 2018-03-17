require "../spec_helper"

describe "Case Branch" do
  subject case_branch

  expect_ignore ""
  expect_ignore "."
  expect_ignore "???"
  expect_ignore "asd"

  expect_error "=>", Parser::CaseBranchExpectedExpression
  expect_error "asd =>", Parser::CaseBranchExpectedExpression

  expect_ok "asd => asd"
end
