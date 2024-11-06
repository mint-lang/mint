module Mint
  class Formatter
    def list(nodes : Array(Ast::Node), delimeter : String? = nil) : Nodes
      list(
        items: nodes.map(&.as(Ast::Node)).zip(nodes.map(&->format(Ast::Node))),
        separator: delimeter)
    end
  end
end
