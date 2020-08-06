module Mint
  class Formatter
    def format(node : Ast::ModuleAccess) : String
      variable =
        format node.variable

      separator =
        if node.constant?
          ":"
        else
          "."
        end

      "#{node.name}#{separator}#{variable}"
    end
  end
end
