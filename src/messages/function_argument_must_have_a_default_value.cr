message FunctionArgumentMustHaveADefaultValue do
  title "Type Error"

  block do
    text "The argument"
    bold name
    text "is declared after one that had a default value."
  end

  block do
    text "Arguments that come after ones that have a default value must also have a default value."
  end

  snippet node
end
