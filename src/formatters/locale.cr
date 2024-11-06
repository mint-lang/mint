module Mint
  class Formatter
    def format(node : Ast::Locale) : Nodes
      ["locale #{node.language} "] +
        group(
          items: [format node.fields],
          behavior: Behavior::Block,
          ends: {"{", "}"},
          separator: "",
          pad: false)
    end
  end
end
