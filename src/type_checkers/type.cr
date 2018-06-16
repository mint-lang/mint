module Mint
  class TypeChecker
    def check(node : Ast::Type) : Type
      type = resolve_alias(node.name) ||
             resolve_record_definition(node.name) || begin
        parameters =
          resolve node.parameters
        Type.new(node.name, parameters)
      end

      types[node] = type
      type
    end
  end
end
