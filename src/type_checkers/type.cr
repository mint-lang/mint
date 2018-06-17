module Mint
  class TypeChecker
    def check(node : Ast::Type) : Checkable
      resolve_record_definition(node.name) || begin
        parameters =
          resolve node.parameters

        Comparer.normalize(Type.new(node.name, parameters))
      end
    end
  end
end
