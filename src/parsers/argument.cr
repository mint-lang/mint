module Mint
  class Parser
    syntax_error ArgumentExpectedTypeOrVariable
    syntax_error ArgumentExpectedDefaultValue
    syntax_error ArgumentExpectedColon

    def argument(parse_default_value : Bool = true) : Ast::Argument?
      start do |start_position|
        next unless name = variable

        whitespace
        char ':', ArgumentExpectedColon
        whitespace

        type = type_or_type_variable! ArgumentExpectedTypeOrVariable

        if parse_default_value
          whitespace
          default =
            if char! '='
              whitespace
              expression! ArgumentExpectedDefaultValue
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
