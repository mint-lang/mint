message UseSubscriptionMismatch do
  title "Type Error"

  block do
    text "The subsctipion of a provider does not match it's definition."
  end

  was_expecting_type expected, got

  snippet node
end
