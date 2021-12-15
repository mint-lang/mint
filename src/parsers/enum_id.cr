module Mint
  class Parser
    syntax_error EnumIdExpectedClosingParentheses
    syntax_error EnumIdExpectedDoubleColon
    syntax_error EnumIdExpectedOption

    def short_enum_id
      start do |start_position|
        next unless char! ':'
        next unless option = type_id

        self << Ast::EnumId.new(
          expressions: enum_id_expressions,
          from: start_position,
          option: option,
          to: position,
          input: data,
          name: nil)
      end
    end

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
        char ')', EnumIdExpectedClosingParentheses
      end

      expressions
    end

    def enum_id
      start do |start_position|
        next unless name = type_id

        keyword! "::", EnumIdExpectedDoubleColon

        option = type_id! EnumIdExpectedOption

        self << Ast::EnumId.new(
          expressions: enum_id_expressions,
          from: start_position,
          option: option,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
