module Mint
  class TypeChecker
    def check(node : Ast::Test)
      resolve node.name

      type =
        resolve node.expression

      if Comparer.compare(type, BOOL) ||
         Comparer.compare(type, TEST_CONTEXT)
      else
        error! :test_type_mismatch do
          block "The type of a test does not match any of the allowed types."
          block "I was expecting one of:"

          snippet "Test.Context(a)\nBool"
          snippet "Instead it is:", type
          snippet "The test in question is here:", node.expression.expressions.last
        end
      end

      VOID
    end
  end
end
