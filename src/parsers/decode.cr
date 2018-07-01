module Mint
  class Parser
    syntax_error DecodeExpectedExpression
    syntax_error DecodeExpectedType
    syntax_error DecodeExpectedAs

    def decode : Ast::Decode | Nil
      start do |start_position|
        skip unless keyword "decode"
        whitespace! SkipError

        expression = expression! DecodeExpectedExpression

        whitespace
        keyword! "as", DecodeExpectedAs
        whitespace

        type = type! DecodeExpectedType

        Ast::Decode.new(
          expression: expression.as(Ast::Expression),
          from: start_position,
          type: type,
          to: position,
          input: data)
      end
    end
  end
end
