module Mint
  class Parser
    def catch_all : Ast::CatchAll?
      start do |start_position|
        next unless keyword "catch"
        whitespace

        expression =
          code_block(
            opening_bracket: CatchExpectedOpeningBracket,
            closing_bracket: CatchExpectedClosingBracket,
            statement_error: CatchExpectedExpression)

        self << Ast::CatchAll.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
