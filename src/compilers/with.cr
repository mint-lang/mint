class Compiler
  def compile(node : Ast::With) : String
    entity =
      ast.modules.find(&.name.==(node.name))

    raise TypeError.new unless entity

    compile node.body
  end
end
