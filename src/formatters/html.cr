module Mint
  class Formatter
    def format(node : Ast::HtmlElement | Ast::HtmlComponent,
               prefix : String,
               tag : String) : String
      attributes =
        format node.attributes

      multiline =
        attributes.size >= 2 || attributes.any?(&.includes?("\n"))

      attributes =
        if attributes.empty?
          ""
        elsif multiline
          indent("\n" + attributes.join("\n"))
        else
          " " + attributes.join(" ")
        end

      children =
        indent(list(node.children + node.comments))

      if node.children.empty?
        "<#{prefix}#{attributes}/>"
      elsif attributes.includes?("\n")
        "<#{prefix}#{attributes}>\n\n#{children}\n\n</#{tag}>"
      else
        "<#{prefix}#{attributes}>\n#{children}\n</#{tag}>"
      end
    end
  end
end
