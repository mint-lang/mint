module Mint
  class Parser
    syntax_error CssDefinitionExpectedSemicolon

    def css_definition : Ast::CssDefinition | Nil
      start do |start_position|
        skip unless char.in_set? "a-z-"

        name = gather do
          step
          chars "a-zA-Z-"
        end

        skip unless char!(':')

        whitespace

        value = many(parse_whitespace: false) do
          css_interpolation || gather { chars "^#;}" }
        end.compact

        char ';', CssDefinitionExpectedSemicolon

        Ast::CssDefinition.new(
          from: start_position,
          name: name.to_s,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
