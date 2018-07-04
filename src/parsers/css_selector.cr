module Mint
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

        body = block(
          opening_bracket: CssSelectorExpectedOpeningBracket,
          closing_bracket: CssSelectorExpectedClosingBracket) do
          many { css_definition || comment }.compact
        end

        definitions = [] of Ast::CssDefinition
        comments = [] of Ast::Comment

        body.each do |item|
          case item
          when Ast::CssDefinition
            definitions << item
          when Ast::Comment
            comments << item
          end
        end

        Ast::CssSelector.new(
          definitions: definitions,
          selectors: selectors,
          from: start_position,
          comments: comments,
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
end
