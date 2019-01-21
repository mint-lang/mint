module Mint
  class Compiler
    def _compile(node : Ast::If) : String
      condition =
        compile node.condition

      truthy =
        compile node.truthy

      falsy =
        compile node.falsy

      "(#{condition} ? #{truthy} : #{falsy})"
    end
  end
end
