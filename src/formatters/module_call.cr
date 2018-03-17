class Formatter
  def format(node : Ast::ModuleCall) : String
    function =
      format node.function

    format "#{node.name}.#{function}", node
  end
end
