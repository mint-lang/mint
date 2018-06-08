message DecodeComplexType do
  title "Type Error"

  block do
    text "This type cannot be automatically decoded:"
  end

  type got

  block do
    text "Only these types and records containing them can"
    text "be automatically decoded:"
  end

  type_list [
    TypeChecker::Type.new("Array", [TypeChecker::Type.new("a")]),
    TypeChecker::Type.new("Maybe", [TypeChecker::Type.new("a")]),
    TypeChecker::STRING,
    TypeChecker::NUMBER,
    TypeChecker::TIME,
    TypeChecker::BOOL,
  ]

  snippet node
end
