message DecodeExpectedExpression do
  title "Syntax Error"

  block do
    text "The"
    bold "object to be decoded "
    text "must come from an"
    bold "expression."
  end

  was_looking_for "expression", got

  snippet node
end
