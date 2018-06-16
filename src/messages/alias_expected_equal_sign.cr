message AliasExpectedEqualSign do
  title "Syntax Error"

  block do
    text "The"
    bold "name"
    text "of an alias and its"
    bold "types"
    text "must be separated by an"
    bold "equal sign"
  end

  was_looking_for "equal sign", got, "="

  snippet node
end
