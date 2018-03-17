class TypeChecker
  def check(node : Ast::Finally) : Type
    check node.expression
  end
end
