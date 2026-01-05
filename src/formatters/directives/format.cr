module Mint
  class Formatter
    def format(node : Ast::Directives::Format) : Nodes
      ["@format "] + format(node.content, BlockFormat::Outdented)
    end
  end
end
