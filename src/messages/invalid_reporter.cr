message InvalidReporter do
  title "Test Runner Error"

  block do
    text "There is no reporter with the name:"
    bold reporter
  end

  block do
    text "The available reporters are:"
  end

  list ["documentation", "dot"]
end
