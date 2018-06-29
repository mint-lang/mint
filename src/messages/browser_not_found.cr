message BrowserNotFound do
  title "Test Runner Error"

  block do
    text "I cannot find the executable of browser:"
    bold browser
  end

  block do
    text "Are you sure it's installed properly?"
  end
end
