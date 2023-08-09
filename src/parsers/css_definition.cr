module Mint
  class Parser
    def css_definition : Ast::CssDefinition?
      start do |start_position|
        next unless char.ascii_lowercase? || char == '-'

        name = gather do
          step
          letters_numbers_or_dash
        end.to_s

        next unless char! ':'
        whitespace

        value =
          many(parse_whitespace: false) do
            string_literal ||
              interpolation ||
              gather do
                consume_while char.in_set?("^;{\0") &&
                              !keyword_ahead?("\#{") &&
                              char != '"'
              end
          end.map do |item|
            if item.is_a?(Ast::StringLiteral) && item.static?
              %("#{item.static_value}")
            else
              item
            end
          end

        next error :css_definition_expected_semicolon do
          expected "the semicolon of a CSS definition", word
          snippet self
        end unless char! ';'

        self << Ast::CssDefinition.new(
          from: start_position,
          name: name,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
