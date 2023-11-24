module Mint
  class Formatter
    def format(
      *,
      node : Ast::HtmlElement | Ast::HtmlComponent,
      prefix : String,
      tag : String
    ) : String
      attributes =
        format node.attributes

      multiline =
        attributes.size >= 2 || attributes.any? do |attribute|
          replace_skipped(attribute).includes?('\n')
        end

      attributes =
        if attributes.empty?
          ""
        elsif multiline
          indent("\n#{attributes.join('\n')}")
        else
          " #{attributes.join(' ')}"
        end

      child_nodes =
        node.children + node.comments

      children =
        indent(list(child_nodes))

      if node.attributes.empty? &&
         node.children.size == 1 &&
         node.children.first.is_a?(Ast::StringLiteral) &&
         !children.includes?('\n')
        "<#{prefix}#{attributes}>#{children.strip}</#{tag}>"
      elsif child_nodes.empty?
        "<#{prefix}#{attributes}/>"
      elsif replace_skipped(attributes).includes?('\n')
        "<#{prefix}#{attributes}>\n\n#{children}\n\n</#{tag}>"
      else
        "<#{prefix}#{attributes}>\n#{children}\n</#{tag}>"
      end
    end
  end
end
