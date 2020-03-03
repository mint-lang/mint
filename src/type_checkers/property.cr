module Mint
  class TypeChecker
    type_error PropertyWithTypeVariables
    type_error PropertyTypeMismatch

    def static_type_signature(node : Ast::Property) : Checkable
      resolve node.type
    end

    def check(node : Ast::Property) : Checkable
      type =
        resolve node.type

      default =
        begin
          resolve node.default
        rescue error : RecordNotFoundMatchingRecord
          error.locals["structure"]?.as(Checkable)
        end

      raise PropertyWithTypeVariables, {
        "type" => type,
        "node" => node,
      } if type.have_holes?

      resolved =
        Comparer.compare type, default

      raise PropertyTypeMismatch, {
        "name"     => node.name.value,
        "got"      => default,
        "expected" => type,
        "node"     => node,
      } unless resolved

      resolved
    end
  end
end
