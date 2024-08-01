module Mint
  class Formatter
    def format(node : Ast::Suite) : Nodes
      body =
        list(node.constants + node.tests + node.comments + node.functions)

      name =
        format node.name

      ["suite "] + name + [" "] + group(
        behavior: Behavior::Block,
        ends: {"{", "}"},
        items: [body],
        separator: "",
        pad: false)
    end
  end
end
