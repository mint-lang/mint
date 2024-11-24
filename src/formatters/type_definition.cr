module Mint
  class Formatter
    def format(node : Ast::TypeDefinition) : Nodes
      parameters =
        format_arguments node.parameters, empty_parenthesis: false

      comment =
        format_documentation_comment node.comment

      name =
        format node.name

      end_comment =
        node.end_comment.try(&->format(Ast::Comment))

      comment + ["type "] + name + parameters + [" "] +
        if node.fields.is_a?(Array(Ast::TypeVariant))
          group(
            items: [list(nodes: node.fields, comment: end_comment)],
            behavior: Behavior::Block,
            ends: {"{", "}"},
            separator: "",
            pad: false)
        else
          group(
            items: [list(nodes: node.fields, separator: ",", comment: end_comment)],
            behavior: Behavior::Block,
            ends: {"{", "}"},
            separator: ",",
            pad: false)
        end
    end
  end
end
