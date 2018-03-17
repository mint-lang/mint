class Parser
  syntax_error CssSelectorExpectedOpeningBracket
  syntax_error CssSelectorExpectedClosingBracket
  syntax_error CssSelectorExpectedName

  syntax_error CssSelectorSpaceAfterAmpersand

  def css_selector : Ast::CssSelector | Nil
    start do |start_position|
      skip unless char == '&'

      selectors = list(
        terminator: '{',
        separator: ','
      ) { css_selector_name }.compact

      definitions = block(
        opening_bracket: CssSelectorExpectedOpeningBracket,
        closing_bracket: CssSelectorExpectedClosingBracket) do
        many { css_definition }.compact
      end

      Ast::CssSelector.new(
        definitions: definitions,
        selectors: selectors,
        from: start_position,
        to: position,
        input: data)
    end
  end

  def css_selector_name : String | Nil
    return unless char! '&'

    colon = char!(':')
    double_colon = keyword("::")

    if !colon && !double_colon
      whitespace! CssSelectorSpaceAfterAmpersand
    end

    name = gather { chars "^,{" }

    raise CssSelectorExpectedName unless name

    name = name.strip

    if colon
      ":#{name}"
    elsif double_colon
      "::#{name}"
    else
      " #{name}"
    end
  end
end
