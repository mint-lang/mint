message CaseUnnecessaryAll do
  title "Type Error"

  block do
    text "All possibilities of the case expression are covered."
  end

  snippet node, "This branch is not needed and can be safely removed."
end
