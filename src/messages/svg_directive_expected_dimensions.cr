message SvgDirectiveExpectedDimensions do
  title "Syntax Error"

  block do
    text "The svg specified for an svg directive does not have the following attributes:"
  end

  list ["width", "height", "viewBox"]

  snippet node
end
