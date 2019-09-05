message MintJsonIconNotExists do
  title "mint.json Error"

  block do
    text "The"
    bold "icon"
    text "field of"
    bold "the application object"
    text "points to a file that does not exists."
  end

  block do
    text "The"
    bold "icon"
    text "field if exists should point to an image."
  end

  block do
    text "That image will used to generate favicons for the application."
  end

  snippet node, nil
end
