message InlineFunctionExpectedArrow do
  title "Syntax Error"

  block do
    text "The"
    bold "arguments"
    text "and the"
    bold "body"
    text "of an inline function must be separated by an"
    bold "arrow."
  end

  was_looking_for "arrow", got, "=>"

  snippet node
end
