message StateExpectedEqualSign do
  title "Syntax Error"

  block do
    text "The"
    bold "type"
    text "of a state and its"
    bold "default value"
    text "must be separated by an"
    bold "equal sign"
  end

  was_looking_for "equal sign", got, "="

  snippet node
end
