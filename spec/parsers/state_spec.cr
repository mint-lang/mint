require "../spec_helper"

describe "State" do
  subject state

  expect_ignore "."
  expect_ignore "::"
  expect_ignore "asd"

  expect_error "state", Parser::StateExpectedColon
  expect_error "state ", Parser::StateExpectedColon
  expect_error "state :", Parser::StateExpectedType
  expect_error "state : ", Parser::StateExpectedType
  expect_error "state : T", Parser::StateExpectedRecord
  expect_error "state : T ", Parser::StateExpectedRecord

  expect_ok "state : T { }"
end
