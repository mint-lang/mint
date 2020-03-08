module Mint
  class Formatter
    def format(node : Ast::HtmlComponent) : String
      component =
        format node.component.value

      ref =
        node.ref.try do |variable|
          name =
            format variable

          " as #{name}"
        end || ""

      format(prefix: component + ref, tag: component, node: node)
    end
  end
end
