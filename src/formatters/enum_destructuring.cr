module Mint
  class Formatter
    def format(node : Ast::EnumDestructuring)
      parameters =
        format node.parameters, " "

      "#{node.name}::#{node.option} #{parameters}"
    end
  end
end
