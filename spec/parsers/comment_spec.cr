require "../spec_helper"

describe "Comment" do
  subject comment

  expect_ok "//\n//"
  expect_ok "// Inline comment\n// Inline comment"
  expect_ok "// // // Inline Comment //\n // //"

  expect_ok "/* Block comment */\n/* Block comment */"
  # Failing Tests
  # expect_ok "/* Block /* comment */ */"
end
