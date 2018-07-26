require "../spec_helper"

describe "Html Fragment" do
  subject html_fragment

  expect_ignore "asd"
  expect_ignore "< "

  expect_error "<>", Mint::Parser::HtmlFragmentExpectedClosingTag

  expect_ok "<></>"
end
