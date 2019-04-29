require "../spec_helper"

describe "Case Branch" do
  subject case_branch

  expect_ignore ""
  expect_ignore "???"
  expect_ignore "asd"

  expect_error "=>", Mint::Parser::CaseBranchExpectedExpression
  expect_error "asd =>", Mint::Parser::CaseBranchExpectedExpression

  expect_ok "asd => asd"
end
