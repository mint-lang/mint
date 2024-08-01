module Mint
  class Formatter
    def format(node : Ast::RegexpLiteral) : Nodes
      format("/#{node.value}/#{node.flags.split.uniq.join}")
    end
  end
end
