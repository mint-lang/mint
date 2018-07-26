module Mint
  class Formatter
    def format(node : Ast::HtmlFragment) : String
      children =
        list(node.children + node.comments).indent

      # There no point of having an empty fragment.
      if node.children.empty?
        ""
      else
        "<>\n#{children}\n</>"
      end
    end
  end
end
