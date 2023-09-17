require "../spec_helper"

describe "Locale" do
  subject locale

  expect_ignore "comp"
  expect_ignore "asd"

  expect_error "locale", Mint::Parser::LocaleExpectedLanguage
  expect_error "locale{", Mint::Parser::LocaleExpectedLanguage
  expect_error "locale ", Mint::Parser::LocaleExpectedLanguage
  expect_error "locale en", Mint::Parser::LocaleExpectedOpeningBracket
  expect_error "locale en {", Mint::Parser::LocaleExpectedClosingBracket

  expect_ok "locale en { a: \"\" }"
end
