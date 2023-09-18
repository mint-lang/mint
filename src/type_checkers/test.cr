module Mint
  class TypeChecker
    def check(node : Ast::Test)
      resolve node.name

      type =
        resolve node.expression

      error! :test_type_mismatch do
        block "The type of a test does not match any of the allowed types."
        block "I was expecting one of:"

        snippet VALID_TEST_TYPES.map(&.to_pretty).join("\n")
        snippet "Instead it is:", type
        snippet "The test in question is here:", node.expression.expressions.last
      end unless Comparer.matches_any? type, VALID_TEST_TYPES

      VOID
    end
  end
end
