require "../spec_helper"

describe "Block Comment" do
  subject comment

  expect_ok "/*\n    Block Comment\n */"
  expect_ok "/*!\n * Block Comment\n */"
  expect_ok "/* Block comment with EOF"
end
