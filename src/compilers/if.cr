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
        falsy_item.try { |item| compile item }

      "(#{condition} ? #{truthy} : #{falsy})"
    end
  end
end
