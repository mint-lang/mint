class Formatter
  def format(node : Ast::Variable) : String
    node.value
  end
end
