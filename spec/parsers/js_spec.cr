require "../spec_helper"

describe "Js" do
  subject js

  expect_ignore "."
  expect_ignore "asd"
  expect_ignore "blah blah"

  expect_error "`asd", Mint::Parser::JsExpectedClosingTick
  expect_error "`sad ${", Mint::Parser::JsInterpolationExpectedExpression
  expect_error "`asd ${x", Mint::Parser::JsInterpolationExpectedClosingBracket

  expect_ok "`hello`"
  expect_ok %(`\`Hello`)
  expect_ok %(`Hello ${blah()}`)
  expect_ok %(`Hello \`${blah()}\``)
  expect_ok %(`Hello ${blah(`"WHAAT"`)}`)
end
