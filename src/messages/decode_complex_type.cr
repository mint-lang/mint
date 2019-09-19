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
    TypeChecker::Type.new("Array", [TypeChecker::Variable.new("a")] of TypeChecker::Checkable),
    TypeChecker::Type.new("Maybe", [TypeChecker::Variable.new("a")] of TypeChecker::Checkable),
    TypeChecker::Type.new("Map", [TypeChecker::STRING, TypeChecker::Variable.new("a")] of TypeChecker::Checkable),
    TypeChecker::STRING,
    TypeChecker::NUMBER,
    TypeChecker::TIME,
    TypeChecker::BOOL,
    TypeChecker::OBJECT,
  ] of TypeChecker::Checkable

  snippet node
end
