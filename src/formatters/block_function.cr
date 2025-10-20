module Mint
  class Formatter
    def format(node : Ast::BlockFunction) : Nodes
      body =
        format node.body, BlockFormat::Naked

      arguments =
        format_arguments node.arguments, block: true

      group(
        behavior: Behavior::BreakAllButFirst,
        items: [arguments, body],
        ends: {"{", "}"},
        separator: "",
        pad: true)
    end
  end
end
