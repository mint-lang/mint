module Mint
  class Formatter
    def format(node : Ast::Pipe) : Nodes
      argument =
        format node.argument

      expression =
        format node.expression

      await =
        if node.await
          format("await ")
        else
          [] of Node
        end

      argument + [Line.new(1), "|> "] of Node + await + expression
    end
  end
end
