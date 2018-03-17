class Compiler
  def compile(node : Ast::Operation) : String
    left =
      compile node.left

    right =
      compile node.right

    "#{left} #{node.operator} #{right}"
  end
end
