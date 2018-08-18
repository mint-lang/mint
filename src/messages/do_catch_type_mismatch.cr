message DoCatchTypeMismatch do
  title "Type Error"

  block do
    text "The return type of a catch does not match the return type"
    text "of the last statement in a do expression."
  end

  was_expecting_type expected, got

  snippet node
end
