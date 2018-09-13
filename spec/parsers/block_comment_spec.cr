require "../spec_helper"

describe "Block Comment" do
  subject block_comment

  expect_ok "/* Block comment */\n/* Block comment */"
  
  # Failing Tests
  # expect_ok "/* Block /* comment */ */"
end
