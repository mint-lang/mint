module Mint
  class TypeChecker
    type_error PropertyTypeMismatch

    def check(node : Ast::Property) : Checkable
      type =
        resolve node.type

      default =
        resolve node.default

      result =
        Comparer.compare type, default

      raise PropertyTypeMismatch, {
        "name"     => node.name.value,
        "got"      => default,
        "expected" => type,
        "node"     => node,
      } unless result

      result
    end
  end
end
