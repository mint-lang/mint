class TypeChecker
  def check(node : Ast::InlineFunction) : Type
    scope node do
      type =
        check node.body

      arguments =
        check node.arguments

      Type.new("Function", arguments + [type])
    end
  end
end
