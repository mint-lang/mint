require "../spec_helper"

describe "Html Fragment" do
  subject html_fragment

  expect_ignore "asd"

  expect_error "< ", Mint::Parser::HtmlFragmentExpectedClosingBracket
  expect_error "<>", Mint::Parser::HtmlFragmentExpectedClosingTag
  expect_error "< a", Mint::Parser::HtmlFragmentExpectedClosingBracket
  expect_error "< ??", Mint::Parser::HtmlFragmentExpectedClosingBracket
  expect_error "< key=\"\"", Mint::Parser::HtmlFragmentExpectedClosingBracket

  expect_ok "<></>"
  expect_ok "<  ></>"
  expect_ok "< key=\"a\"></>"
  expect_ok "< key=\"a\" ></>"
end
