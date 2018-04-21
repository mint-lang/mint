message ArrayNotMatches do
  title "Type Error"

  block do
    text "The"
    bold "#{index}. item"
    text "of an array does not match the type of the first item."
  end

  block do
    text "I was expecting the same type as of the first item:"
  end

  type expected

  block do
    text "Instead it is:"
  end

  type got

  snippet node
end
