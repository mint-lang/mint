module Mint
  class Formatter
    def format(node : Ast::Pipe) : Nodes
      argument =
        format node.argument

      expression =
        format node.expression

      argument + [Line.new(1), "|> "] of Node + expression
    end
  end
end
