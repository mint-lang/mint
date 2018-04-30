message HtmlAttributeExpectedEqualSign do
  title "Syntax Error"

  block do
    text "The"
    bold "name of an attribute"
    text "and its"
    bold "value"
    text "must be separated by an"
    bold "equal sign"
    code "="
  end

  was_looking_for "equal sign", got, "="

  snippet node
end
