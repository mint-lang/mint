module Mint
  class Formatter2
    def format(node : Ast::Type) : Nodes
      name =
        format node.name

      if node.parameters.empty?
        name
      else
        parameters =
          format_arguments node.parameters

        name + parameters
      end
    end
  end
end
