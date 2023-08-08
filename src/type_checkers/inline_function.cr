module Mint
  class TypeChecker
    def check(node : Ast::InlineFunction) : Checkable
      check_arguments(node.arguments)

      body_type =
        resolve node.body

      arguments =
        resolve node.arguments

      final_type =
        Type.new("Function", arguments + [body_type])

      resolved_type =
        if type = node.type
          return_type =
            resolve type

          defined_type =
            Comparer.normalize(Type.new("Function", arguments + [return_type]))

          resolved =
            Comparer.compare(defined_type, final_type)

          error! :inline_function_type_mismatch do
            block "The return type of an anonymous function does not match its type definition."

            snippet "I was expecting:", return_type
            snippet "Which is defined here:", type
            snippet "Instead it is:", body_type
            snippet "Which is returned here:", node.body.expressions.last
          end unless resolved

          Comparer.normalize(defined_type)
        else
          Comparer.normalize(final_type)
        end

      resolved_type.optional_count = node.arguments.count(&.default)
      resolved_type
    end
  end
end
