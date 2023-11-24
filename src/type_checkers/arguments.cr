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
  end
end
