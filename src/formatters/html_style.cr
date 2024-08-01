module Mint
  class Formatter
    def format(node : Ast::HtmlStyle) : Nodes
      ["::#{node.name.value}"] +
        format_arguments(
          empty_parenthesis: false,
          nodes: node.arguments)
    end
  end
end
