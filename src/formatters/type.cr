class Formatter
  def format(node : Ast::Type) : String
    parameters =
      format node.parameters, ", "

    if parameters.empty?
      node.name
    else
      "#{node.name}(#{parameters})"
    end
  end
end
