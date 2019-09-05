module Mint
  class TypeChecker
    type_error PropertyWithTypeVariables
    type_error PropertyTypeMismatch

    def check(node : Ast::Property) : Checkable
      type =
        resolve node.type

      default =
        resolve node.default

      raise PropertyWithTypeVariables, {
        "type" => type,
        "node" => node,
      } if type.have_holes?

      result =
        Comparer.compare type, default

      raise PropertyTypeMismatch, {
        "name"     => node.name.value,
        "got"      => default,
        "expected" => type,
        "node"     => node,
      } unless result

      type
    end
  end
end
