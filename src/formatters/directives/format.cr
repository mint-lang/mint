module Mint
  class Formatter
    def format(node : Ast::Directives::Format) : Nodes
      ["@format "] + format(node.content)
    end
  end
end
