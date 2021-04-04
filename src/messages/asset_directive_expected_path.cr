message AssetDirectiveExpectedPath do
  title "Syntax Error"

  block do
    text "An asset directive must specify the path to the file (relative to the current file)."
  end

  was_looking_for "path", got

  snippet node
end
