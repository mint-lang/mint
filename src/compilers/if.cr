module Mint
  class Compiler
    def _compile(node : Ast::If) : String
      condition =
        compile node.condition

      truthy_item, falsy_item =
        node.branches

      truthy =
        compile truthy_item

      falsy =
        compile falsy_item

      "(#{condition} ? #{truthy} : #{falsy})"
    end
  end
end
