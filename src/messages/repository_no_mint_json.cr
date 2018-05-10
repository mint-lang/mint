message RepositoryNoMintJson do
  title "Install Error"

  block do
    text "I could not find the mint.json for the package:"
    bold id
    text "for the version or tag:"
    bold target
  end
end
