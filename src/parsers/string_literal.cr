module Mint
  class Parser
    def string_literal(*, with_interpolation : Bool = true) : Ast::StringLiteral?
      parse do |start_position|
        next unless char! '"'

        value =
          many(parse_whitespace: false) do
            if with_interpolation
              raw('"') || interpolation
            else
              raw('"')
            end
          end

        next error :string_expected_closing_quote do
          expected "the closing quoute of a string literal", word
          snippet self
        end unless char! '"'

        # Look ahead to see if there is a backslash (string separator), if
        # parsing fails it will track the whitespace back.
        broken =
          parse do
            whitespace
            next unless char! '\\'
            true
          end || false

        to =
          position

        # If it's separated try to parse an other part.
        if broken
          whitespace

          literal =
            string_literal(with_interpolation: with_interpolation)

          next error :string_expected_other_string do
            expected "another string literal after a string separator", word
            snippet self
          end unless literal

          value.concat(literal.value)
        end

        # Normalize the value so there are consecutive strings.
        value =
          value.reduce([] of Ast::Interpolation | String) do |memo, item|
            if memo.last?.is_a?(String) && item.is_a?(String)
              memo << (memo.pop.as(String) + item.as(String))
            else
              memo << item
            end

            memo
          end

        Ast::StringLiteral.new(
          from: start_position,
          broken: broken,
          value: value,
          file: file,
          to: to)
      end
    end
  end
end
