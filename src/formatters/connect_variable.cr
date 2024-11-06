module Mint
  class Formatter
    def format(node : Ast::ConnectVariable) : Nodes
      name =
        format node.name

      if target = node.target
        name + [" as "] + format(target)
      else
        name
      end
    end
  end
end
