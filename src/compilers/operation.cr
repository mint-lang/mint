module Mint
  class Compiler
    def _compile(node : Ast::Operation) : String
      left =
        compile node.left

      right =
        compile node.right

      case node.operator
      when "=="
        "_compare(#{left}, #{right})"
      when "!="
        "!_compare(#{left}, #{right})"
      else
        "#{left} #{node.operator} #{right}"
      end
    end
  end
end
