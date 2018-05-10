message MintJsonNameIsEmpty do
  title "mint.json Error"

  block do
    text "The"
    bold "name"
    text "field of a"
    bold "mint.json"
    text "file is empty:"
  end

  snippet node, nil
end
