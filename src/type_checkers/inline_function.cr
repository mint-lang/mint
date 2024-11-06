module Mint
  class TypeChecker
    def check(node : Ast::InlineFunction)
      check_function(node)
    end
  end
end
