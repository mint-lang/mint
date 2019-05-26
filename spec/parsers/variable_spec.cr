require "../spec_helper"

describe "Variable" do
  subject variable

  expect_ignore " "
  expect_ignore "."
  expect_ignore "???"

  expect_ok "a"
  expect_ok "asd"
  expect_ok "asdAsd"
  expect_ok "asd_"
end

describe "Variable!" do
  subject variable!(Mint::SyntaxError)

  expect_error " ", Mint::SyntaxError
  expect_error ".", Mint::SyntaxError
  expect_error "???", Mint::SyntaxError
end

describe "Variable With Dashes" do
  subject variable_with_dashes

  expect_ignore " "
  expect_ignore "."
  expect_ignore "???"

  expect_ok "a"
  expect_ok "asd-ada-sd---asd"
  expect_ok "asd"
  expect_ok "asdAsd"
  expect_ok "asd_"
end

describe "Variable Attribute Name" do
  subject variable_attribute_name

  expect_ignore " "
  expect_ignore "."
  expect_ignore "???"

  expect_ok "a"
  expect_ok "asd-ada-sd---asd"
  expect_ok "asd"
  expect_ok "asdAsd"
  expect_ok "asd-::asd"
end

describe "Variable With Dashes!" do
  subject variable_with_dashes!(Mint::SyntaxError)

  expect_error " ", Mint::SyntaxError
  expect_error ".", Mint::SyntaxError
  expect_error "???", Mint::SyntaxError
end
