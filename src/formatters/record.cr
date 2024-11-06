module Mint
  class Formatter
    def format(node : Ast::Record, multiline = false) : Nodes
      if node.fields.empty?
        format("{ }")
      else
        group(
          items: node.fields.map(&->format(Ast::Node)),
          behavior: Behavior::BreakAll,
          ends: {"{", "}"},
          separator: ",",
          pad: true)
      end
    end
  end
end
