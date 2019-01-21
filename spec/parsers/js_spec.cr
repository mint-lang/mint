require "../spec_helper"

describe "Js" do
  subject js

  expect_ignore "."
  expect_ignore "asd"
  expect_ignore "blah blah"

  expect_error %q(`asd"), Mint::Parser::JsExpectedClosingTick
  expect_error %q(`sad #{), Mint::Parser::JsInterpolationExpectedExpression
  expect_error %q(`asd #{x), Mint::Parser::JsInterpolationExpectedClosingBracket

  expect_ok %q(`hello`)
  expect_ok %q(`\`Hello`)
  expect_ok %q(`Hello ##somehting`)
  expect_ok %q(`Hello #{blah()}`)
  expect_ok %q(`Hello \`#{blah()}\``)
  expect_ok %q(`Hello #{blah(`"WHAAT"`)}`)
end
