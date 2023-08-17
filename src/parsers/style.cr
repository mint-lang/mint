module Mint
  class Parser
    def style : Ast::Style?
      start do |start_position|
        next unless keyword "style"

        whitespace
        next error :style_expected_name do
          expected "the name of a style", word
          snippet self
        end unless name = variable_with_dashes
        whitespace

        arguments = [] of Ast::Argument

        if char! '('
          whitespace
          arguments = list(terminator: ')', separator: ',') { argument }
          whitespace

          next error :style_expected_closing_parenthesis do
            expected "the closing parenthesis of a style", word
            snippet self
          end unless char! ')'
        end

        body = block2(
          ->{ error :style_expected_opening_bracket do
            expected "the opening bracket of a style", word
            snippet self
          end },
          ->{ error :style_expected_closing_bracket do
            expected "the closing bracket of a style", word
            snippet self
          end }
        ) do
          items = many { css_keyframes || css_font_face || css_node }

          error :style_expected_body do
            expected "the body of a style", word
            snippet self
          end if items.empty?

          items
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
    rescue ex : Error
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
