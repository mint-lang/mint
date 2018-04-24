message ComponentStyleNameConflict do
  title "Type Error"

  block do
    text "There are multiple style definitions with the name:"
    bold "#{name}."
  end

  snippet node, "One definition is here:"
  snippet other, "An other definition is here:"
end
