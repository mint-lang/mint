module Mint
  class Formatter
    def format(node : Ast::Type) : Nodes
      parameters =
        format_arguments node.parameters, empty_parenthesis: false

      name =
        format node.name

      name + parameters
    end
  end
end
