module Mint
  class Compiler
    def compile(node : Ast::If) : String
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
