module Mint
  class Parser
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

          expressions.concat list(
            terminator: ')',
            separator: ','
          ) { expression.as(Ast::Expression) }.compact

          whitespace
          char ')', SyntaxError
        end

        Ast::EnumId.new(
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
