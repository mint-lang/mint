class Compiler
  def compile(node : Ast::Statement) : String
    compile node.expression
  end
end
