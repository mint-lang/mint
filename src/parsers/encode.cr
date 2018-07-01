module Mint
  class Parser
    syntax_error EncodeExpectedExpression

    def encode : Ast::Encode | Nil
      start do |start_position|
        skip unless keyword "encode"

        whitespace! SkipError

        expression = expression! EncodeExpectedExpression

        Ast::Encode.new(
          expression: expression.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
