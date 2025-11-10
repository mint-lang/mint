module Mint
  class Parser
    def argument(*, parse_default_value : Bool = true) : Ast::Argument?
      parse do |start_position|
        next unless name = variable

        whitespace
        next error :argument_expected_colon do
          snippet "A colon must separate the arguments name from its type, " \
                  "here is an example:", "name : String"
          expected "the colon of the argument", word
          snippet self
        end unless char! ':'

        whitespace
        next error :argument_expected_type do
          snippet "An argument must have its type defined, here is an " \
                  "example:", "name : Type"
          expected "the type of the argument", word
          snippet self
        end unless type = types

        if parse_default_value
          whitespace

          if char! '='
            whitespace
            default = expression

            next error :argument_expected_default_value do
              block do
                text "The"
                bold "default value"
                text "of an argument must be defined after the equal sign, " \
                     "here is an example:"
              end

              snippet %(name : String = "Joe")
              expected "the default value of the argument", word
              snippet self
            end unless default
          end
        end

        Ast::Argument.new(
          from: start_position,
          default: default,
          to: position,
          file: file,
          name: name,
          type: type)
      end
    end
  end
end
