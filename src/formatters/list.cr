module Mint
  class Formatter
    def list(
      nodes : Array(Ast::Node),
      separator : String? = nil,
      comment : Nodes? = nil,
    ) : Nodes
      [
        List.new(
          items: nodes.map(&.as(Ast::Node)).zip(nodes.map(&->format(Ast::Node))),
          separator: separator,
          comment: comment),
      ] of Node
    end
  end
end
