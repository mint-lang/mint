message ArgumentExpectedTypeOrVariable do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "type of the argument"
    text "but found "
    code got
    text "instead."
  end

  snippet node
end
