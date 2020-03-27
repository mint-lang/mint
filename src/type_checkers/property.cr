module Mint
  class TypeChecker
    type_error PropertyTypeOrDefaultNeeded
    type_error PropertyWithTypeVariables
    type_error PropertyTypeMismatch

    def static_type_signature(node : Ast::Property) : Checkable
      node.type.try { |type| resolve type } || Variable.new("a")
    end

    def check(node : Ast::Property) : Checkable
      default =
        node.default.try do |item|
          begin
            resolve item
          rescue error : RecordNotFoundMatchingRecord
            error.locals["structure"]?.as(Checkable)
          end
        end

      type =
        node.type.try do |item|
          resolve item
        end

      final =
        case {default, type}
        when {Checkable, Checkable}
          resolved =
            Comparer.compare type, default

          raise PropertyTypeMismatch, {
            "name"     => node.name.value,
            "got"      => default,
            "expected" => type,
            "node"     => node,
          } unless resolved

          resolved
        when {Checkable, Nil}
          default
        when {Nil, Checkable}
          type
        else
          raise PropertyTypeOrDefaultNeeded, {
            "node" => node,
          }
        end

      raise PropertyWithTypeVariables, {
        "type" => final,
        "node" => node,
      } if final.have_holes?

      final
    end
  end
end
