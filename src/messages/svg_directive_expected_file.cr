message SvgDirectiveExpectedFile do
  title "Syntax Error"

  block do
    text "The svg specified for an svg directive does not exists."
  end

  block do
    text "The file should be here: #{path}"
  end

  snippet node
end
