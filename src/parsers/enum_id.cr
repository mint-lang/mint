module Mint
  class Parser
    syntax_error EnumIdExpectedClosingParentheses
    syntax_error EnumIdExpectedDoubleColon
    syntax_error EnumIdExpectedOption

    def enum_id_expressions
      expressions = [] of Ast::Expression

      if char! '('
        whitespace

        item = enum_record

        if item
          expressions << item
        else
          expressions.concat list(
            terminator: ')',
            separator: ','
          ) { expression }
        end

        whitespace
        return unless char! ')'
      end

      expressions
    end

    def enum_id
      start do |start_position|
        next unless option = type_id track: false

        if keyword "::"
          name = option
          option = type_id! EnumIdExpectedOption, track: false
        end

        self << Ast::EnumId.new(
          expressions: enum_id_expressions || [] of Ast::Expression,
          from: start_position,
          option: option,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
