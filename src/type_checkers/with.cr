module Mint
  class TypeChecker
    type_error WithNotFoundModule

    def check(node : Ast::With) : Checkable
      entity =
        ast.modules.find(&.name.==(node.name))

      raise WithNotFoundModule, {
        "name" => node.name,
        "node" => node,
      } unless entity

      check! entity

      scope entity do
        resolve node.body
      end
    end
  end
end
