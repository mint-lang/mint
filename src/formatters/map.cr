module Mint
  class Formatter
    def format(node : Ast::Map) : Nodes
      types =
        format(node.types) do |items|
          [" of "] + format(items[0]) + [" => "] + format(items[1])
        end

      if node.fields.empty?
        format("{ }")
      else
        group(
          items: node.fields.map(&->format(Ast::Node)),
          behavior: Behavior::BreakAll,
          ends: {"{", "}"},
          separator: ",",
          pad: true)
      end + types
    end
  end
end
