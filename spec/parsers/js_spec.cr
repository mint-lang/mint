require "../spec_helper"

describe "Js" do
  subject js

  expect_ignore "."
  expect_ignore "asd"
  expect_ignore "blah blah"

  expect_error "`asd", Parser::JsExpectedClosingTick

  expect_ok "`hello`"
  expect_ok %(`\`Hello`)
end
