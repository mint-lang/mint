module Mint
  class Parser
    syntax_error StyleExpectedClosingParentheses
    syntax_error StyleExpectedOpeningBracket
    syntax_error StyleExpectedClosingBracket
    syntax_error StyleExpectedName

    def style : Ast::Style | Nil
      start do |start_position|
        skip unless keyword "style"
        whitespace! SkipError

        name = variable_with_dashes! StyleExpectedName
        whitespace

        arguments = [] of Ast::Argument

        if char! '('
          whitespace

          arguments.concat list(
            terminator: ')',
            separator: ','
          ) { argument }.compact

          whitespace
          char ')', StyleExpectedClosingParentheses
        end

        body = block(
          opening_bracket: StyleExpectedOpeningBracket,
          closing_bracket: StyleExpectedClosingBracket
        ) do
          css_body
        end

        Ast::Style.new(
          from: start_position,
          arguments: arguments,
          to: position,
          input: data,
          body: body,
          name: name)
      end
    end

    def css_body
      many {
        comment ||
          case_expression(for_css: true) ||
          if_expression(for_css: true) ||
          css_media ||
          css_definition_or_selector
      }.compact
    end

    def css_definition_or_selector
      css_definition || css_selector
    rescue definition_errror : CssDefinitionExpectedSemicolon
      begin
        css_selector
      rescue
        raise definition_errror
      end
    end
  end
end
