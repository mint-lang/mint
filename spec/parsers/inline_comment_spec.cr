require "../spec_helper"

describe "Inline Comment" do
  subject inline_comment

  expect_ok "//\n//"
  expect_ok "// Inline comment\n// Inline comment"
  expect_ok "// // // Inline Comment //\n // //"
end
