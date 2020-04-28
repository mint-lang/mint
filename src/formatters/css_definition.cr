module Mint
  class Formatter
    def format(node : Ast::CssDefinition) : String
      head =
        "#{node.name}: "

      value =
        format(node.value)
          .join
          .remove_all_leading_whitespace
          .indent(head.size)
          .lstrip

      "#{head}#{value};"
    end
  end
end
