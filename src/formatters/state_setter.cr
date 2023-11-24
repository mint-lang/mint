module Mint
  class Formatter
    def format(node : Ast::StateSetter) : String
      entity =
        node
          .entity
          .try(&->format(Ast::Id))
          .try { |item| "#{item}" }

      "-> #{entity}#{node.state.value}"
    end
  end
end
