module Mint
  class Formatter
    def format(node : Ast::HtmlComponent) : Nodes
      component =
        format node.component.value

      ref =
        format(node.ref) do |item|
          [" as "] + format(item)
        end

      format(prefix: component + ref, tag: component, node: node)
    end
  end
end
