module Mint
  class Formatter
    def format(node : Ast::If) : String
      condition =
        format node.condition

      truthy_item, falsy_item =
        node.branches

      truthy =
        case truthy_item
        when Array(Ast::CssDefinition)
          "{\n#{indent(list(truthy_item))}\n}"
        when Ast::Node
          format truthy_item
        else
          ""
        end

      falsy =
        if falsy_item.is_a?(Ast::If)
          " else #{format(falsy_item)}"
        else
          body =
            case falsy_item
            when Array(Ast::CssDefinition)
              "{\n#{indent(list(falsy_item))}\n}"
            when Ast::Node
              format falsy_item
            end

          " else #{body}" if body
        end

      condition =
        if replace_skipped(condition).includes?('\n')
          condition
            .remove_all_leading_whitespace
            .indent(4)
            .lstrip
        else
          condition
        end

      "if #{condition} #{truthy}#{falsy}"
    end
  end
end
