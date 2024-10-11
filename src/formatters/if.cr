module Mint
  class Formatter
    def format(node : Ast::If) : Nodes
      target =
        case item = node.condition
        when Ast::Statement
          item.only_expression?
        end || item

      condition =
        case item = target
        when Ast::ParenthesizedExpression
          format item.expression
        when Ast::Statement
          format item, false
        else
          format item
        end

      truthy_item, falsy_item =
        node.branches

      truthy =
        case truthy_item
        when Array(Ast::CssDefinition)
          group(
            items: [list(truthy_item)],
            behavior: Behavior::Block,
            ends: {"{", "}"},
            separator: "",
            pad: false)
        when Ast::Node
          format truthy_item
        else
          [] of Node
        end

      falsy =
        if falsy_item.is_a?(Ast::If)
          [" else "] + format(falsy_item)
        else
          body =
            case falsy_item
            when Array(Ast::CssDefinition)
              group(
                behavior: Behavior::Block,
                items: [list(falsy_item)],
                ends: {"{", "}"},
                separator: "",
                pad: false)
            when Ast::Node
              format falsy_item
            end

          if body
            [" else "] + body
          else
            [] of Node
          end
        end

      ["if "] + condition + [" "] + truthy + falsy
    end
  end
end
