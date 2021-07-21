message RuntimeFileNotFound do
  title "Runtime Error"

  block do
    text "The specified runtime file"
    code path
    text "could not be found"
  end
end
