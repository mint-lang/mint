class Parser
  syntax_error CssDefinitionExpectedSemicolon
  syntax_error CssDefinitionExpectedColon

  def css_definition : Ast::CssDefinition | Nil
    start do |start_position|
      skip unless char.in_set? "a-z-"

      name = gather do
        step
        chars "a-zA-Z-"
      end

      char ':', CssDefinitionExpectedColon

      whitespace

      value = many(parse_whitespace: false) do
        css_interpolation || gather { chars "^{;}" }
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
