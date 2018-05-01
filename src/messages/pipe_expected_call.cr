message PipeExpectedCall do
  title "Syntax Error"

  block do
    text "I was looking for a function to pipe the result into but found"
    code got
    text "instead."
  end

  snippet node
end
