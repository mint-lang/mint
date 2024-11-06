module Mint
  class Formatter
    def format(node : Ast::Argument) : Nodes
      default =
        format node.default

      name =
        format node.name

      type =
        format node.type

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
