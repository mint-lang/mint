module Mint
  class TypeChecker
    def check(node : Ast::Style) : Checkable
      check_arguments(node.arguments)

      resolve node.body

      arguments = resolve node.arguments
      arguments << VOID

      type = Type.new("Function", arguments)
      type.optional_count = node.arguments.count(&.default)
      type
    end
  end
end
