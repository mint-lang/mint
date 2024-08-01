module Mint
  class Formatter
    def format(node : Ast::StateSetter) : Nodes
      entity =
        format(node.entity) do |item|
          format(item) + ["."]
        end

      ["-> "] + entity + [node.state.value]
    end
  end
end
