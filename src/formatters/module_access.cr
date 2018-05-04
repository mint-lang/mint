module Mint
  class Formatter
    def format(node : Ast::ModuleAccess) : String
      variable =
        format node.variable

      "#{node.name}.#{variable}"
    end
  end
end
