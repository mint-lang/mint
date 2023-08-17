module Mint
  class TypeChecker
    def check(node : Ast::Test)
      resolve node.name

      type =
        resolve node.expression

      if Comparer.compare(type, BOOL) ||
         Comparer.compare(type, TEST_CONTEXT)
      else
        error :test_type_mismatch do
          block "The type of a test does not match any of the allowed types."
          block "I was expecting one of:"

          snippet "Bool, Test.Context(a)"
          snippet "Instead it is:", type
          snippet node.expression
        end
      end

      VOID
    end
  end
end
