module Mint
  class TypeChecker
    def check(node : Ast::Function)
      check_function(node)
    end

    def check_function(node : Ast::Function | Ast::InlineFunction) : Checkable
      check_arguments(node.arguments)

      arguments =
        resolve node.arguments

      body_type =
        resolve node.body

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

          error_type, error_entity =
            case node
            in Ast::Function
              {
                :function_type_mismatch,
                "a function",
              }
            in Ast::InlineFunction
              {
                :inline_function_type_mismatch,
                "an anonymous function",
              }
            end

          error! error_type do
            block "The return type of #{error_entity} does not match its type definition."

            snippet "I was expecting:", return_type
            snippet "Which is defined here:", type
            snippet "Instead it is:", body_type
            snippet "Which is returned here:", node.body.expressions.last
          end unless resolved

          resolved
        else
          Comparer.normalize(final_type)
        end

      resolved_type.optional_count = node.arguments.count(&.default)
      resolved_type
    end
  end
end
