module Mint
  class Formatter2
    def format(node : Ast::CaseBranch) : Nodes
      expression =
        case item = node.expression
        when Array(Ast::CssDefinition)
          list item
        when Ast::Node
          format item
        else
          [] of Node
        end

      pattern =
        head =
          if node.pattern
            format(node.pattern) + [" => "]
          else
            ["=> "] of Node
          end

      head + expression
    end
  end
end
