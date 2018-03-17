require "../spec_helper"

describe "String Literal" do
  subject string_literal

  expect_ignore "."
  expect_ignore "a"
  expect_ignore "blahblahblah"

  expect_error %("asd), Parser::StringExpectedEndQuote
  expect_error %("asd" \\), Parser::StringExpectedOtherString

  expect_ok %("OK")
  expect_ok %("\"OK")
  expect_ok %("OK"\\"OK")
  expect_ok %("OK" \\ "OK")
end
