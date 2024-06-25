module Mint
  class Formatter2
    def format(node : Ast::TypeDefinition) : Nodes
      name =
        format node.name

      comment =
        node.comment.try { |item| format(item) + [:ln] } || [] of Node

      parameters =
        format_arguments(node.parameters)

      comment + ["type "] + name + [" "] + parameters +
        group(
          separator: node.fields.is_a?(Array(Ast::TypeVariant)) ? "," : "",
          behavior: Behavior::Block,
          items: node.fields,
          ends: {"{", "}"})
    end
  end
end
