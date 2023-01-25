require "../spec_helper"

describe "Decode Expression" do
  subject decode

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "decode", Mint::Parser::DecodeExpectedExpression
  expect_error "decode x", Mint::Parser::DecodeExpectedAs
  expect_error "decode x x", Mint::Parser::DecodeExpectedAs
  expect_error "decode x ?", Mint::Parser::DecodeExpectedAs
  expect_error "decode x as", Mint::Parser::DecodeExpectedType
  expect_error "decode x as x", Mint::Parser::DecodeExpectedType

  expect_ok "decode as T"
  expect_ok "decode x as T"
end
