require "../../spec_helper"

describe "Documentation Directive" do
  subject documentation_directive

  expect_ignore "?"
  expect_ignore "."
  expect_ignore "@docu"

  expect_error "@documentation", Mint::Parser::DocumentationDirectiveExpectedOpeningParntheses
  expect_error "@documentation(", Mint::Parser::DocumentationDirectiveExpectedEntity
  expect_error "@documentation(A", Mint::Parser::DocumentationDirectiveExpectedClosingParntheses

  expect_ok "@documentation(a)"
  expect_ok "@documentation( a )"
end
