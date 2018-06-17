module Mint
  class TypeChecker
    def check(node : Ast::InlineFunction) : Checkable
      scope node do
        type =
          resolve node.body

        arguments =
          resolve node.arguments

        Type.new("Function", arguments + [type])
      end
    end
  end
end
