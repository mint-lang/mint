module Mint
  class Formatter
    def format(node : Ast::HtmlFragment) : String
      children =
        indent(list(node.children + node.comments))

      if node.key
        key =
          format node.key

        if node.children.empty?
          "< #{key}></>"
        else
          "< #{key}>\n#{children}\n</>"
        end
      else
        if node.children.empty?
          "<></>"
        else
          "<>\n#{children}\n</>"
        end
      end
    end
  end
end
