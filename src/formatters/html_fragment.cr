module Mint
  class Formatter
    def format(node : Ast::HtmlFragment) : String
      children =
        list(node.children + node.comments)

      key =
        node.key.try { |item| " #{format(item)}" }

      if node.new_line?
        "<#{key}>\n#{indent(children)}\n</>"
      else
        "<#{key}>#{children}</>"
      end
    end
  end
end
