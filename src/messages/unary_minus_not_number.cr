message UnaryMinusNotNumber do
  title "Type Error"

  block do
    text "An unary minuses expression must evaluate to number."
  end

  was_expecting_type expected, got

  snippet node
end
