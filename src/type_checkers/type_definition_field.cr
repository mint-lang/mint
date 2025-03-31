module Mint
  class TypeChecker
    def check(node : Ast::TypeDefinitionField) : Checkable
      resolve(node.type).tap do |type|
        if definition = ast.type_definitions.find(&.name.value.==(type.name))
          resolve(definition)
        end
      end
    end
  end
end
