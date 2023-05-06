module Mint
  class Parser
    syntax_error HtmlComponentExpectedClosingBracket
    syntax_error HtmlComponentExpectedClosingTag
    syntax_error HtmlComponentExpectedReference
    syntax_error HtmlComponentExpectedType

    def html_component : Ast::HtmlComponent?
      start do |start_position|
        component = start do
          next unless char! '<'
          type_id HtmlComponentExpectedType
        end

        next unless component

        ref = start do
          whitespace
          next unless keyword "as"
          whitespace
          variable! HtmlComponentExpectedReference
        end

        attributes, children, comments = html_body(
          expected_closing_bracket: HtmlComponentExpectedClosingBracket,
          expected_closing_tag: HtmlComponentExpectedClosingTag,
          with_dashes: false,
          tag: component)

        node = self << Ast::HtmlComponent.new(
          attributes: attributes,
          from: start_position,
          component: component,
          children: children,
          comments: comments,
          to: position,
          input: data,
          ref: ref)

        refs << {ref, node} if ref

        node
      end
    end
  end
end
