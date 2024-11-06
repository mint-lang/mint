module Mint
  class Formatter
    def format(node : Ast::Signal) : Nodes
      comment =
        format_documentation_comment node.comment

      block =
        format node.block

      name =
        format node.name

      type =
        format node.type

      comment + ["signal "] + name + [" : "] + type + [" "] + block
    end
  end
end
