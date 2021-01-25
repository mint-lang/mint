module Mint
  class Parser
    syntax_error ArgumentExpectedTypeOrVariable
    syntax_error ArgumentExpectedColon

    def argument : Ast::Argument?
      start do |start_position|
        skip unless name = variable

        whitespace
        char ':', ArgumentExpectedColon
        whitespace

        type = type_or_type_variable! ArgumentExpectedTypeOrVariable

        self << Ast::Argument.new(
          from: start_position,
          to: position,
          input: data,
          name: name,
          type: type)
      end
    end
  end
end
