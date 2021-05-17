require "../spec_helper"

describe "Try" do
  subject try_expression

  expect_ignore ""
  expect_ignore "asd"
  expect_ignore "??"
  expect_ignore "tr"

  expect_error "try ", Mint::Parser::TryExpectedOpeningBracket
  expect_error "try {", Mint::Parser::TryExpectedStatement
  expect_error "try {}", Mint::Parser::TryExpectedStatement
  expect_error "try { a", Mint::Parser::TryExpectedClosingBracket

  expect_ok "try {a}"
  expect_ok "try { a }"
end
