message RecordFieldExpectedEqualSign do
  title "Syntax Error"

  block do
    text "The"
    bold "name of a field"
    text "and its"
    bold "value"
    text "must be separated by an"
    bold "equal sign"
  end

  was_looking_for "equal sign", got, "="

  snippet node
end
