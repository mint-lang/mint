module Mint
  class TypeChecker
    type_error PropertyTypeMismatch
    type_error PropertyNotHole

    def check(node : Ast::Property) : Checkable
      type =
        resolve node.type

      default =
        resolve node.default

      raise PropertyNotHole, {
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
