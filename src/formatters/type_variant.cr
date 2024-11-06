module Mint
  class Formatter
    def format(node : Ast::TypeVariant) : Nodes
      comment =
        format_documentation_comment(node.comment)

      parameters =
        format_arguments(node.parameters, empty_parenthesis: false)

      comment + format(node.value) + parameters
    end
  end
end
