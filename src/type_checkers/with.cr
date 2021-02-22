module Mint
  class TypeChecker
    type_error WithNotFoundModule

    def check(node : Ast::With) : Checkable
      entity =
        ast.unified_modules.find(&.name.==(node.name))

      raise WithNotFoundModule, {
        "name" => node.name,
        "node" => node,
      } unless entity

      check! entity

      scope.push entity do
        resolve node.body
      end
    end
  end
end
