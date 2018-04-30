message IfElseTypeMismatch do
  title "Type Error"

  block do
    text "The"
    bold "falsy (else) branch of an if expression"
    text "does not match the type of the truthy branch."
  end

  was_expecting_type expected, got

  snippet node
end
