message JsExpectedTypeOrVariable do
  title "Syntax Error"

  block do
    text "The type of"
    bold "inlined JavaScript"
    text "must be defined after the"
    bold "as"
    text "keyword."
  end

  was_looking_for "type", got

  snippet node
end
