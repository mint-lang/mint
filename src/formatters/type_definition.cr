module Mint
  class Formatter
    def format(node : Ast::TypeDefinition) : Nodes
      parameters =
        format_arguments node.parameters, empty_parenthesis: false

      comment =
        format_documentation_comment node.comment

      name =
        format node.name

      comment + ["type "] + name + parameters + [" "] +
        if node.fields.is_a?(Array(Ast::TypeVariant))
          group(
            behavior: Behavior::Block,
            items: [list(node.fields)],
            ends: {"{", "}"},
            separator: "",
            pad: false)
        else
          group(
            items: [list(node.fields, ",")],
            behavior: Behavior::Block,
            ends: {"{", "}"},
            separator: ",",
            pad: false)
        end
    end
  end
end
