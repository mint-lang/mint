module Mint
  class Parser
    syntax_error CatchExpectedOpeningBracket
    syntax_error CatchExpectedClosingBracket
    syntax_error CatchExpectedExpression
    syntax_error CatchExpectedVariable
    syntax_error CatchExpectedArrow
    syntax_error CatchExpectedType

    def catch : Ast::Catch | Nil
      start do |start_position|
        skip unless keyword "catch"

        whitespace
        type = type_id! CatchExpectedType
        whitespace

        keyword! "=>", CatchExpectedArrow
        whitespace
        variable = variable! CatchExpectedVariable

        head_comments, expression, tail_comments = block_with_comments(
          opening_bracket: CatchExpectedOpeningBracket,
          closing_bracket: CatchExpectedClosingBracket) do
          expression! CatchExpectedExpression
        end

        Ast::Catch.new(
          expression: expression.as(Ast::Expression),
          head_comments: head_comments,
          tail_comments: tail_comments,
          from: start_position,
          variable: variable,
          to: position,
          input: data,
          type: type)
      end
    end
  end
end
