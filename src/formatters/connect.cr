module Mint
  class Formatter
    def format(node : Ast::Connect) : Nodes
      store =
        format node.store

      keys =
        group(
          items: node.keys.map(&->format(Ast::Node)),
          behavior: Behavior::BreakAll,
          ends: {"{", "}"},
          separator: ",",
          pad: true)

      ["connect "] + store + [" exposing "] + keys
    end
  end
end
