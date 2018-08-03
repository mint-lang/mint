module Mint
  class Parser
    # syntax_error EnumOptionExpectedClosingParentheses

    def enum_option
      start do |start_position|
        comment = self.comment

        value = type_id! SkipError
        whitespace

        parameters = [] of Ast::TypeVariable | Ast::Type

        if char! '('
          whitespace

          parameters.concat list(
            terminator: ')',
            separator: ','
          ) { type_variable || type }.compact

          whitespace
          char ')', SyntaxError
        end

        Ast::EnumOption.new(
          parameters: parameters,
          from: start_position,
          comment: comment,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
