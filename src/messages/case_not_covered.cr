message CaseNotCovered do
  title "Type Error"

  block do
    text "Not all possibilities of a case expression are covered."
  end

  block do
    text "To cover all remaining possibilities add an empty case branch:"
  end

  pre "=> return value"

  snippet node
end
