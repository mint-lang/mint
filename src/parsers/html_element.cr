module Mint
  class Parser
    syntax_error HtmlElementExpectedClosingBracket
    syntax_error HtmlElementExpectedClosingTag
    syntax_error HtmlElementExpectedReference
    syntax_error HtmlElementExpectedStyle

    def html_element : Ast::HtmlElement | Nil
      start do |start_position|
        tag = start do
          skip unless char! '<'
          skip unless value = variable_with_dashes
          value
        end

        skip unless tag

        if keyword "::"
          style = variable_with_dashes! HtmlElementExpectedStyle
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

        node = Ast::HtmlElement.new(
          attributes: attributes,
          from: start_position,
          children: children,
          comments: comments,
          style: style,
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
