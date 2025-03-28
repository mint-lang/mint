module Mint
  class Formatter
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

      pattern, separator =
        if patterns = node.patterns
          if patterns.size == 1
            {format(patterns.first), " =>"}
          else
            {
              group(
                items: patterns.map(&->format(Ast::Node)),
                behavior: Behavior::BreakAll,
                separator: " |",
                ends: {"", ""},
                pad: false,
              ), " =>",
            }
          end
        else
          {[] of Node, "=>"}
        end

      break_not_fits(
        items: {pattern, expression},
        separator: separator)
    end
  end
end
