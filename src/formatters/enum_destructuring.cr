module Mint
  class Formatter
    def format(node : Ast::EnumDestructuring)
      parameters =
        format node.parameters, " "

      if parameters.empty?
        "#{node.name}::#{node.option}"
      else
        "#{node.name}::#{node.option} #{parameters}"
      end
    end
  end
end
