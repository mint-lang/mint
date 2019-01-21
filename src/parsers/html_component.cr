module Mint
  class Parser
    syntax_error HtmlComponentExpectedClosingBracket
    syntax_error HtmlComponentExpectedClosingTag
    syntax_error HtmlComponentExpectedReference
    syntax_error HtmlComponentExpectedType

    def html_component : Ast::HtmlComponent | Nil
      start do |start_position|
        component = start do
          skip unless char! '<'
          skip unless value = type_id HtmlComponentExpectedType
          value
        end

        skip unless component

        ref = start do
          whitespace
          skip unless keyword "as"
          whitespace
          variable! HtmlComponentExpectedReference
        end

        attributes, children, comments = html_body(
          expected_closing_bracket: HtmlComponentExpectedClosingBracket,
          expected_closing_tag: HtmlComponentExpectedClosingTag,
          with_dashes: false,
          tag: component)

        node = Ast::HtmlComponent.new(
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
