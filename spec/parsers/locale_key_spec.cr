require "../spec_helper"

describe "Locale" do
  subject locale_key

  expect_ignore "comp"
  expect_ignore "asd"
  expect_ignore ":"

  expect_ok ":ui.button.ok"
end
