module Mint
  class Parser
    def argument(parse_default_value : Bool = true) : Ast::Argument?
      start do |start_position|
        next unless name = variable

        whitespace
        next error :argument_expected_colon do
          block "A colon must separate the arguments name from its type."
          expected "the colon of the argument", word

          snippet self
        end unless char! ':'

        whitespace
        next error :argument_expected_type do
          block "An argument must have its type defined."
          expected "the type of the argument", word

          snippet self
        end unless type = type_or_type_variable

        if parse_default_value
          whitespace

          if char! '='
            whitespace
            default = expression

            next error :argument_expected_default_value do
              block do
                text "The"
                bold "default value"
                text "of an argument must be defined after the equal sign."
              end

              snippet %(name : String = "Joe")

              expected "the default value of the argument", word

              snippet self
            end unless default
          end
        end

        self << Ast::Argument.new(
          from: start_position,
          default: default,
          to: position,
          input: data,
          name: name,
          type: type)
      end
    end
  end
end
