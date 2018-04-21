message CatchExpectedArrow do
  title "Syntax Error"

  block do
    text "The variable and the type of "
    bold "a catch "
    text "must be separated by "
    bold "an arrow."
  end

  block do
    text "I was looking for that "
    bold "arrow "
    code "=>"
    text " but found "
    code got
    text " instead."
  end

  snippet node
end
