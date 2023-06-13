module Mint
  class Parser
    syntax_error DecodeExpectedExpression
    syntax_error DecodeExpectedType
    syntax_error DecodeExpectedAs

    def decode : Ast::Decode?
      start do |start_position|
        next unless keyword "decode"
        next unless whitespace?
        whitespace

        unless keyword "as"
          expression = expression! DecodeExpectedExpression

          whitespace
          keyword! "as", DecodeExpectedAs
        end

        whitespace
        type = type! DecodeExpectedType

        self << Ast::Decode.new(
          expression: expression,
          from: start_position,
          type: type,
          to: position,
          input: data)
      end
    end
  end
end
