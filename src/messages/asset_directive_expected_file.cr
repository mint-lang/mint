message AssetDirectiveExpectedFile do
  title "Syntax Error"

  block do
    text "The path specified for an asset directive does not exists."
  end

  block do
    text "The file should be here: "
    bold path
  end

  snippet node
end
