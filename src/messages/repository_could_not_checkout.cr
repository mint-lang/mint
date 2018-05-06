message RepositoryCouldNotCheckout do
  title "Install Error"

  block do
    text "I could not checkout the version or tag:"
    bold target
    text "of the repository:"
    bold url
  end

  block do
    text "The error I got from the git command is this:"
  end

  block do
    bold result.to_s.strip
  end
end
