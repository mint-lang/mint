module Mint
  class Parser
    syntax_error CatchExpectedOpeningBracket
    syntax_error CatchExpectedClosingBracket
    syntax_error CatchExpectedExpression
    syntax_error CatchExpectedVariable
    syntax_error CatchExpectedArrow

    def catch : Ast::Catch?
      start do |start_position|
        next unless keyword "catch"

        whitespace
        next unless type = type_id
        whitespace

        keyword! "=>", CatchExpectedArrow

        whitespace
        variable = variable! CatchExpectedVariable
        whitespace

        expression =
          code_block(
            opening_bracket: CatchExpectedOpeningBracket,
            closing_bracket: CatchExpectedClosingBracket,
            statement_error: CatchExpectedExpression)

        self << Ast::Catch.new(
          expression: expression,
          from: start_position,
          variable: variable,
          to: position,
          input: data,
          type: type)
      end
    end
  end
end
