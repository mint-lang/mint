message SvgDirectiveExpectedSvg do
  title "Syntax Error"

  block do
    text "The svg specified for an svg directive is not an SVG file (could not parse it)."
  end

  list errors

  snippet node
end
