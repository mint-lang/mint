module Mint
  class Formatter2
    def format(node : Ast::Argument) : Nodes
      name =
        format node.name

      type =
        format node.type

      default =
        format node.default

      head =
        name + [" : "] + type

      if default.empty?
        head
      else
        head + [" = "] + default
      end
    end
  end
end
