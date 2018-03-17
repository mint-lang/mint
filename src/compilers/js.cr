class Compiler
  def compile(node : Ast::Js) : String
    node.value.strip
  end
end
