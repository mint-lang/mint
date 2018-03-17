class Parser
  syntax_error StyleExpectedOpeningBracket
  syntax_error StyleExpectedClosingBracket
  syntax_error StyleExpectedName

  def style : Ast::Style | Nil
    start do |start_position|
      skip unless keyword "style"

      whitespace

      name = variable_with_dashes! StyleExpectedName

      body = block(
        opening_bracket: StyleExpectedOpeningBracket,
        closing_bracket: StyleExpectedClosingBracket
      ) do
        many { css_definition || css_selector }.compact
      end

      definitions = [] of Ast::CssDefinition
      selectors = [] of Ast::CssSelector

      body.each do |item|
        case item
        when Ast::CssDefinition
          definitions << item
        when Ast::CssSelector
          selectors << item
        end
      end

      Ast::Style.new(
        definitions: definitions,
        selectors: selectors,
        from: start_position,
        to: position,
        input: data,
        name: name)
    end
  end
end
