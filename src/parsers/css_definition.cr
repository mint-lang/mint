module Mint
  class Parser
    def css_definition : Ast::CssDefinition?
      parse do |start_position|
        next unless char.ascii_lowercase? || char == '-'
        next unless name = gather { ascii_letters_or_numbers(extra_char: '-') }
        next unless char! ':'
        whitespace

        value =
          many(parse_whitespace: false) {
            string_literal || interpolation || raw { char.in_set?("^;{\0\"") }
          }.map do |item|
            if item.is_a?(Ast::StringLiteral) && (raw = static_value(item))
              %("#{raw}")
            else
              item
            end
          end

        next error :css_definition_expected_semicolon do
          expected "the semicolon of a CSS definition", word
          snippet self
        end unless char! ';'

        Ast::CssDefinition.new(
          from: start_position,
          to: position,
          value: value,
          name: name,
          file: file)
      end
    end
  end
end
