module Mint
  class TypeChecker
    type_error TestTypeMismatch

    def check(node : Ast::Test)
      type =
        check node.expression

      if Comparer.compare(type, BOOL) ||
         Comparer.compare(type, TEST_CONTEXT)
      else
        raise TestTypeMismatch, {
          "node" => node.expression,
          "got"  => type,
        }
      end

      NEVER
    end
  end
end
