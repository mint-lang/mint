message MintJsonHeadNotExists do
  title "mint.json Error"

  block do
    text "The"
    bold "head"
    text "field of"
    bold "the application object"
    text "points to a file that does not exists."
  end

  block do
    text "The"
    bold "head"
    text "field if exists should point to a HTML file."
  end

  block do
    text "That HTML file will be injected to the HEAD of the generated HTML."
    text "It is used to include external dependencies"
    text "(CSS, JS, analytics, etc...)"
  end

  snippet node, nil
end
