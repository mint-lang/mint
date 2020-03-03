module Mint
  class TypeChecker
    type_error StateTypeMismatch

    def static_type_signature(node : Ast::State) : Checkable
      resolve node.type
    end

    def check(node : Ast::State) : Checkable
      type =
        resolve node.type

      default =
        begin
          resolve node.default
        rescue error : RecordNotFoundMatchingRecord
          error.locals["structure"]?.as(Checkable)
        end

      resolved =
        Comparer.compare(type, default)

      raise StateTypeMismatch, {
        "expected" => type,
        "name"     => node.name.value,
        "node"     => node.default,
        "got"      => default,
      } unless resolved

      resolved
    end
  end
end
