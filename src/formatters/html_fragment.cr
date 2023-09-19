module Mint
  class Formatter
    def format(node : Ast::HtmlFragment) : String
      children =
        list(node.children + node.comments)

      if node.new_line?
        "<>\n#{indent(children)}\n</>"
      else
        "<>#{children}</>"
      end
    end
  end
end
