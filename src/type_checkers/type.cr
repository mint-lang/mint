module Mint
  class TypeChecker
    def check(node : Ast::Type) : Checkable
      resolve_record_definition(node.name.value) || begin
        parameters =
          resolve node.parameters

        Comparer.normalize(Type.new(node.name.value, parameters))
      end
    end
  end
end
