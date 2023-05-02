module Mint
  class Formatter
    def format(node : Ast::Type) : String
      parameters =
        format node.parameters, ", "

      if parameters.empty?
        format node.name
      else
        "#{format node.name}(#{parameters})"
      end
    end
  end
end
