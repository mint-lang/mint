message MintJsonInvalidFile do
  title "mint.json Error"

  block do
    text "There was a problem when I was trying to open a"
    bold "mint.json"
    text "file:"
    bold path
  end

  block do
    text "The error I got is this:"
  end

  block do
    bold result
  end
end
