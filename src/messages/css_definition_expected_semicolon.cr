message CssDefinitionExpectedSemicolon do
  title "Syntax Error"

  block do
    text "All CSS definitions must end in a semicolon."
  end

  was_looking_for "semicolon", got, ";"

  snippet node
end
