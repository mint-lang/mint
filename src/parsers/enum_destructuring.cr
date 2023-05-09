module Mint
  class Parser
    syntax_error EnumDestructuringExpectedDoubleColon
    syntax_error EnumDestructuringExpectedOption
    syntax_error EnumDestructuringExpectedClosingParentheses

    def enum_destructuring
      start do |start_position|
        next unless option = type_id

        if keyword "::"
          name = option
          option = type_id! EnumDestructuringExpectedOption
        end

        parameters = [] of Ast::Node

        if char! '('
          parameters.concat list(
            terminator: ')',
            separator: ','
          ) { destructuring }

          whitespace
          char ')', EnumDestructuringExpectedClosingParentheses
        end

        self << Ast::EnumDestructuring.new(
          parameters: parameters,
          from: start_position,
          option: option,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
