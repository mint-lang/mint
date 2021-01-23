require "../spec_helper"

describe "Constant" do
  subject constant

  expect_ignore "prop"
  expect_ignore "asd"

  expect_error "const ", Mint::Parser::ConstantExpectedName
  expect_error "const .", Mint::Parser::ConstantExpectedName
  expect_error "const a", Mint::Parser::ConstantExpectedName
  expect_error "const A", Mint::Parser::ConstantExpectedEqualSign
  expect_error "const A ", Mint::Parser::ConstantExpectedEqualSign
  expect_error "const A =", Mint::Parser::ConstantExpectedValue
  expect_error "const A = ", Mint::Parser::ConstantExpectedValue

  expect_ok "const A = a"
  expect_ok "const ASD_ASD = a"
end
