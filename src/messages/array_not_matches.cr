message ArrayNotMatches do
  title "Type Error"

  block do
    text "The type of the "
    bold "#{index}. item"
    text " of an array literal does not match the type of the first item."
  end

  block do
    text "Expected the type of the first item "
    code expected
    text " but got "
    code got
    text " instead."
  end

  snippet node
end
