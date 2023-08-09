module Mint
  class Parser
    syntax_error StyleExpectedClosingParentheses
    syntax_error StyleExpectedOpeningBracket
    syntax_error StyleExpectedClosingBracket
    syntax_error StyleExpectedName

    def style : Ast::Style?
      start do |start_position|
        next unless keyword "style"

        whitespace
        name = variable_with_dashes! StyleExpectedName
        whitespace

        arguments = [] of Ast::Argument

        if char! '('
          whitespace

          arguments = list(terminator: ')', separator: ',') { argument }

          whitespace
          char ')', StyleExpectedClosingParentheses
        end

        body = block(
          opening_bracket: StyleExpectedOpeningBracket,
          closing_bracket: StyleExpectedClosingBracket
        ) do
          many { css_keyframes || css_font_face || css_node }
        end

        self << Ast::Style.new(
          from: start_position,
          arguments: arguments,
          to: position,
          input: data,
          body: body,
          name: name)
      end
    end

    def css_node
      comment ||
        case_expression(for_css: true) ||
        if_expression(for_css: true) ||
        css_nested_at ||
        css_definition_or_selector
    end

    def css_body
      many { css_node }
    end

    def css_definition_or_selector
      css_definition || css_selector
    rescue ex : Error2
      if ex.name == :css_definition_expected_semicolon
        begin
          css_selector.tap do |item|
            raise ex unless item
          end
        rescue
          raise ex
        end
      else
        raise ex
      end
    end
  end
end
