message RepositoryInvalidMintJson do
  title "Install Error"

  block do
    text "I could not parse the mint.json for the package:"
    bold id
    text "for the version or tag:"
    bold target
  end
end
