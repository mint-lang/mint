module Mint
  class Parser
    syntax_error EnumIdExpectedClosingParentheses
    syntax_error EnumIdExpectedDoubleColon
    syntax_error EnumIdExpectedOption

    def enum_id
      start do |start_position|
        skip unless name = type_id

        keyword! "::", EnumIdExpectedDoubleColon

        option = type_id! EnumIdExpectedOption

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
            ) { expression }.compact
          end

          whitespace
          char ')', EnumIdExpectedClosingParentheses
        end

        self << Ast::EnumId.new(
          expressions: expressions,
          from: start_position,
          option: option,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
