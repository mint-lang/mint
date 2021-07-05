module Mint
  class Compiler
    def _compile(node : Ast::Operation) : Codegen::Node
      left =
        compile node.left

      right =
        compile node.right

      case node.operator
      when "or"
        Codegen.join ["(", left, "._0 || ", right, ")"]
      when "=="
        Codegen.join ["_compare(", left, ", ", right, ")"]
      when "!="
        Codegen.join ["!_compare(", left, ", ", right, ")"]
      else
        Codegen.join [left, node.operator, right], " "
      end
    end
  end
end
