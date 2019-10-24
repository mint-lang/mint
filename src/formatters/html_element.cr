module Mint
  class Formatter
    def format(node : Ast::HtmlElement) : String
      tag =
        format node.tag

      styles =
        format node.styles

      prefix =
        if styles
          "#{tag}::#{styles.join("::")}"
        else
          tag
        end

      ref =
        node.ref.try do |variable|
          name =
            format variable

          " as #{name}"
        end || ""

      format(prefix: prefix + ref, tag: tag, node: node)
    end
  end
end
