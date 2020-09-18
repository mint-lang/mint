require "../spec_helper"

describe "Regexp Literal" do
  subject regexp_literal

  expect_ignore "."
  expect_ignore "a"
  expect_ignore "blahblahblah"

  expect_error "/", Mint::Parser::RegexpLiteralExpectedClosingSlash

  expect_ok "/\\dsomething_other/"
  expect_ok "/.*?/gm"
end
