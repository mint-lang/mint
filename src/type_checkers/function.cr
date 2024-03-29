module Mint
  class TypeChecker
    def check_arguments(arguments : Array(Ast::Argument))
      was_default = false

      arguments.each do |argument|
        name =
          argument.name.value

        other =
          (arguments - [argument]).find(&.name.value.==(name))

        error! :function_argument_must_have_a_default_value do
          block do
            text "The argument"
            bold %("#{name}")
            text "is declared after one that had a default value."
          end

          block "Arguments that come after ones that have a default value must also have a default value."

          snippet "The argument in question is here:", argument
        end if was_default && !argument.default

        was_default = true if argument.default

        error! :function_argument_conflict do
          block do
            text "The argument"
            bold %("#{name}")
            text "is declared multiple times."
          end

          snippet "It is declared here:", other
          snippet "It is also declared here:", argument
        end if other
      end
    end

    def check(node : Ast::Function) : Checkable
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

          error! :function_type_mismatch do
            block "The return type of a function does not match its type definition."

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
