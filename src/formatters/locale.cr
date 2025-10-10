module Mint
  class Formatter
    def format(node : Ast::Locale) : Nodes
      ["locale #{node.language} "] +
        group(
          items: node.fields.map(&->format(Ast::Node)),
          behavior: Behavior::Block,
          ends: {"{", "}"},
          separator: ",",
          pad: false)
    end
  end
end
