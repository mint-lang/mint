module Mint
  class Parser
    syntax_error HtmlElementExpectedClosingBracket
    syntax_error HtmlElementExpectedClosingTag
    syntax_error HtmlElementExpectedReference
    syntax_error HtmlElementExpectedStyle

    def html_element : Ast::HtmlElement?
      start do |start_position|
        tag = start do
          skip unless char! '<'
          skip unless value = variable_with_dashes track: false
          value
        end

        skip unless tag

        styles = [] of Ast::HtmlStyle

        if keyword_ahead "::"
          styles.concat(many(parse_whitespace: false) do
            html_style
          end.compact)

          raise HtmlElementExpectedStyle if styles.empty?
        end

        ref = start do
          whitespace
          skip unless keyword "as"
          whitespace
          variable! HtmlElementExpectedReference
        end

        attributes, children, comments = html_body(
          expected_closing_bracket: HtmlElementExpectedClosingBracket,
          expected_closing_tag: HtmlElementExpectedClosingTag,
          with_dashes: true,
          tag: tag)

        node = self << Ast::HtmlElement.new(
          attributes: attributes,
          from: start_position,
          children: children,
          comments: comments,
          styles: styles,
          to: position,
          input: data,
          tag: tag,
          ref: ref)

        refs << {ref, node} if ref

        node
      end
    end
  end
end
