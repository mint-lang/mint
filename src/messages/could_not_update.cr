message CouldNotUpdate do
  title "Install Error"

  block do
    text "I could not update the repository:"
    bold url
  end

  block do
    text "The error I got from the git command is this:"
  end

  block do
    bold result.to_s.strip
  end
end
