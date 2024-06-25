module Mint
  class Formatter2
    def format(node : Ast::Record, multiline = false) : Nodes
      [
        Group.new(
          items: node.fields.map(&->format(Ast::Node)),
          ends: {"{", "}"},
          separator: ",",
          pad: true),
      ] of Node
    end
  end
end
