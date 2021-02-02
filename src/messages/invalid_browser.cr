message InvalidBrowser do
  title "Test Runner Error"

  block do
    text "I cannot run the tests in the given browser:"
    bold browser
  end

  block do
    text "The available browsers are:"
  end

  list %w[chrome firefox]
end
