module Mint
  class Parser
    syntax_error HtmlElementExpectedClosingBracket
    syntax_error HtmlElementExpectedClosingTag
    syntax_error HtmlElementExpectedReference
    syntax_error HtmlElementExpectedStyle

    def html_element : Ast::HtmlElement?
      start do |start_position|
        tag = start do
          next unless char! '<'
          next unless value = variable_with_dashes track: false
          value
        end

        next unless tag

        styles = [] of Ast::HtmlStyle

        if keyword_ahead "::"
          styles = many(parse_whitespace: false) { html_style }

          raise HtmlElementExpectedStyle if styles.empty?
        end

        ref = start do
          whitespace
          next unless keyword "as"
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
