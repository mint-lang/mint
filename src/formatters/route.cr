module Mint
  class Formatter
    def format(node : Ast::Route) : Nodes
      entity(
        tail: node.await ? (format("await") + [" "]) : format(""),
        arguments: node.arguments.map(&->format(Ast::Node)),
        head: format(node.url)) + format(node.expression)
    end
  end
end
