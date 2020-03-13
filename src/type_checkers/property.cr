module Mint
  class TypeChecker
    type_error PropertyWithTypeVariables
    type_error PropertyTypeMismatch

    def static_type_signature(node : Ast::Property) : Checkable
      node.type.try { |type| resolve type } || Variable.new("a")
    end

    def check(node : Ast::Property) : Checkable
      default =
        begin
          resolve node.default
        rescue error : RecordNotFoundMatchingRecord
          error.locals["structure"]?.as(Checkable)
        end

      final =
        if item = node.type
          type =
            resolve item

          resolved =
            Comparer.compare type, default

          raise PropertyTypeMismatch, {
            "name"     => node.name.value,
            "got"      => default,
            "expected" => type,
            "node"     => node,
          } unless resolved

          resolved
        else
          default
        end

      raise PropertyWithTypeVariables, {
        "type" => final,
        "node" => node,
      } if final.have_holes?

      final
    end
  end
end
