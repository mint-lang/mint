require "../spec_helper"

describe "Component Property" do
  subject constant

  expect_ignore "prop"
  expect_ignore "asd"

  expect_error "constant", Mint::Parser::ConstantExpectedName
  expect_error "constant ", Mint::Parser::ConstantExpectedName
  expect_error "constant .", Mint::Parser::ConstantExpectedName
  expect_error "constant a", Mint::Parser::ConstantExpectedName
  expect_error "constant A", Mint::Parser::ConstantExpectedEqualSign
  expect_error "constant A ", Mint::Parser::ConstantExpectedEqualSign
  expect_error "constant A =", Mint::Parser::ConstantExpectedValue
  expect_error "constant A = ", Mint::Parser::ConstantExpectedValue

  expect_ok "constant A = a"
  expect_ok "constant ASD_ASD = a"
end
