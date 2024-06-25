module Mint
  class Formatter2
    def format(node : Ast::Module) : Nodes
      items =
        node.functions +
          node.comments +
          node.constants

      body =
        list items

      comment =
        documentation_comment node.comment

      comment + ["module "] + format(node.name) + [" {", Indent.new([:ln] + body), :ln, "}"]
    end
  end
end
