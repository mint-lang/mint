module Mint
  class TypeChecker
    type_error StateTypeMismatch

    def check(node : Ast::State) : Checkable
      record =
        resolve node.type

      type =
        resolve node.default

      resolved =
        Comparer.compare(record, type)

      raise StateTypeMismatch, {
        "expected" => record,
        "name"     => node.name.value,
        "node"     => node.default,
        "got"      => type,
      } unless resolved

      resolved
    end
  end
end
