message RouteParamInvalid do
  title "Type Error"

  block do
    text "The type of parameter "
    bold name
    text "cannot be used in routes."
  end

  type got

  block do
    text "Only these types can be used as route params:"
  end

  type_list [
    TypeChecker::STRING,
    TypeChecker::NUMBER,
  ] of TypeChecker::Checkable

  snippet node
end
