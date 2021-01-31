module Mint
  class Parser
    syntax_error StringExpectedEndQuote
    syntax_error StringExpectedOtherString

    def string_literal!(error : SyntaxError.class, with_interpolation : Bool = true) : Ast::StringLiteral
      node = string_literal(with_interpolation)
      raise error unless node
      node
    end

    def string_literal(with_interpolation : Bool = true) : Ast::StringLiteral?
      start do |start_position|
        skip unless char! '"'

        value = many(parse_whitespace: false) do
          if with_interpolation
            (not_interpolation_part('"') || interpolation)
          else
            not_interpolation_part('"')
          end.as(Ast::Interpolation | String?)
        end.compact

        char '"', StringExpectedEndQuote
        whitespace

        broken = false

        if char! '\\'
          whitespace
          literal = string_literal(with_interpolation)
          raise StringExpectedOtherString unless literal
          broken = true
          value.concat(literal.value)
        else
          track_back_whitespace
        end

        # Normalize the value so there are consecutive Strings
        value =
          value.reduce([] of Ast::Interpolation | String) do |memo, item|
            if memo.last?.is_a?(String) && item.is_a?(String)
              memo << (memo.pop.as(String) + item.as(String))
            else
              memo << item
            end

            memo
          end

        self << Ast::StringLiteral.new(
          from: start_position,
          broken: broken,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
