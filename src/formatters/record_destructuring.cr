module Mint
  class Formatter
    def format(node : Ast::RecordDestructuring) : Nodes
      if node.fields.empty?
        format("{ }")
      else
        group(
          items: node.fields.map(&->format(Ast::Node)),
          behavior: Behavior::BreakAll,
          comment: [] of Node,
          ends: {"{", "}"},
          separator: ",",
          pad: true)
      end
    end
  end
end
