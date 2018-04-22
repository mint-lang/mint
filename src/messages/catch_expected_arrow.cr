message CatchExpectedArrow do
  title "Syntax Error"

  block do
    text "The variable and the type of"
    bold "a catch"
    text "must be separated by"
    bold "an arrow."
  end

  was_looking_for "arrow", got, "=>"

  snippet node
end
