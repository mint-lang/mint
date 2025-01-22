module Mint
  class Formatter
    def format(
      *,
      node : Ast::HtmlElement | Ast::HtmlComponent,
      prefix : Nodes,
      tag : Nodes,
    ) : Nodes
      child_nodes =
        node.children + node.comments

      attributes =
        group(
          items: node.attributes.map(&->format(Ast::Node)),
          behavior: Behavior::BreakAll,
          ends: {"", ""},
          separator: "",
          pad: false)

      children =
        group(
          behavior: Behavior::BreakAll,
          items: [list(child_nodes)],
          ends: {"", ""},
          separator: "",
          pad: false)

      head =
        ["<"] + prefix + (node.attributes.empty? ? ([] of Node) : [" "])

      if child_nodes.empty?
        head + attributes + ["/>"]
      else
        head + attributes + [">"] + children + ["</"] + tag + [">"]
      end
    end
  end
end
