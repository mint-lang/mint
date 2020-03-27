module Mint
  class TypeChecker
    type_error StateTypeMismatch

    def static_type_signature(node : Ast::State) : Checkable
      node.type.try { |type| resolve type } || Variable.new("a")
    end

    def check(node : Ast::State) : Checkable
      default =
        begin
          resolve node.default
        rescue error : RecordNotFoundMatchingRecord
          error.locals["structure"]?.as(Checkable)
        end

      if item = node.type
        type =
          resolve item

        resolved =
          Comparer.compare(type, default)

        raise StateTypeMismatch, {
          "expected" => type,
          "name"     => node.name.value,
          "node"     => node.default,
          "got"      => default,
        } unless resolved

        resolved
      else
        default
      end
    end
  end
end
