require "../spec_helper"

describe "Js" do
  subject js

  expect_ignore "."
  expect_ignore "asd"
  expect_ignore "blah blah"

  expect_error %q(`asd"), Mint::Parser::JsExpectedClosingTick
  expect_error %q(`sad #{), Mint::Parser::InterpolationExpectedExpression
  expect_error %q(`asd #{x), Mint::Parser::InterpolationExpectedClosingBracket
  expect_error %q(`asd` as), Mint::Parser::JsExpectedTypeOrVariable

  expect_ok %q(`hello`)
  expect_ok %q(`hello` as String)
  expect_ok %q(`\`Hello`)
  expect_ok %q(`Hello ##something`)
  expect_ok %q(`Hello #{blah()}`)
  expect_ok %q(`Hello \`#{blah()}\``)
  expect_ok %q(`Hello #{blah(`"WHAAT"`)}`)
end
