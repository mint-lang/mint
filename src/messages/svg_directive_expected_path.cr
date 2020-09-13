message SvgDirectiveExpectedPath do
  title "Syntax Error"

  block do
    text "An svg directive must specifiy the path to the SVG file (relative to the current file)."
  end

  was_looking_for "path", got

  snippet node
end
