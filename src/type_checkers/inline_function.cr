module Mint
  class TypeChecker
    def check(node : Ast::BlockFunction)
      check_function(node)
    end

    def check(node : Ast::InlineFunction)
      check_function(node)
    end
  end
end
