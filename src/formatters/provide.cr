module Mint
  class Formatter
    def format(node : Ast::Provide) : Nodes
      fields =
        group(
          items: node.fields.map(&->format(Ast::Node)),
          behavior: Behavior::BreakAll,
          ends: {"{", "}"},
          separator: ",",
          pad: true)

      ["provide "] + fields + [" "] + format(node.body)
    end
  end
end
