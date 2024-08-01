module Mint
  class Formatter
    def format(node : Ast::RecordUpdate) : Nodes
      expression =
        format node.expression

      ["{ "] + expression + [" |"] +
        group(
          items: node.fields.map(&->format(Ast::Node)),
          behavior: Behavior::BreakAll,
          ends: {"", "}"},
          separator: ",",
          pad: true)
    end
  end
end
