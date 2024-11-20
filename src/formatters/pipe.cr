module Mint
  class Formatter
    def format(node : Ast::Pipe) : Nodes
      comment =
        format_documentation_comment node.comment

      argument =
        format node.argument

      expression =
        format node.expression

      argument + ([Line.new(1)] of Node) + comment + (["|> "] of Node) + expression
    end
  end
end
