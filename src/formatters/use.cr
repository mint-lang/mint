module Mint
  class Formatter
    def format(node : Ast::Use) : Nodes
      data =
        format node.data

      condition =
        format(node.condition) do |item|
          [" when "] + group(
            behavior: Behavior::BreakAll,
            items: [format(item)],
            ends: {"{", "}"},
            separator: ",",
            pad: true)
        end

      prefix =
        if node.context?
          "provide"
        else
          "use"
        end

      ["#{prefix} "] + format(node.provider) + [" "] + data + condition
    end
  end
end
