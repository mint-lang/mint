module Mint
  class Compiler
    def _compile(node : Ast::BracketAccess) : String
      type =
        cache[node.expression]

      expression =
        compile node.expression

      index =
        case item = node.index
        when Ast::NumberLiteral
          item.value.to_i
        when Ast::Node
          compile node.index.as(Ast::Node)
        end

      if type.name == "Tuple" && node.index.is_a?(Ast::NumberLiteral)
        "#{expression}[#{index}]"
      else
        "_at(#{expression}, #{index})"
      end
    end
  end
end
