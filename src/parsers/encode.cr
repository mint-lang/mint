module Mint
  class Parser
    syntax_error EncodeExpectedExpression

    def encode : Ast::Encode?
      start do |start_position|
        next unless keyword "encode"
        next unless whitespace?
        whitespace

        expression = expression! EncodeExpectedExpression

        self << Ast::Encode.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
