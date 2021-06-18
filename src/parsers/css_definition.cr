module Mint
  class Parser
    syntax_error CssDefinitionExpectedSemicolon

    def css_definition : Ast::CssDefinition?
      start do |start_position|
        next unless char.in_set? "a-z-"

        name = gather do
          step
          chars "a-zA-Z0-9-"
        end.to_s

        next unless char! ':'
        whitespace

        value =
          many(parse_whitespace: false) do
            string_literal ||
              interpolation ||
              gather do
                consume_while char.in_set?("^;{\0") &&
                              !keyword_ahead("\#{") &&
                              char != '"'
              end
          end.map do |item|
            if item.is_a?(Ast::StringLiteral) && item.static?
              %("#{item.static_value}")
            else
              item
            end
          end

        char ';', CssDefinitionExpectedSemicolon

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
