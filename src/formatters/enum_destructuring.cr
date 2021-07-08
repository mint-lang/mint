module Mint
  class Formatter
    def format(node : Ast::EnumDestructuring)
      parameters =
        format node.parameters, ", "

      name =
        "#{node.name}::" if node.name

      if parameters.empty?
        "#{name}#{node.option}"
      else
        "#{name}#{node.option}(#{parameters})"
      end
    end
  end
end
