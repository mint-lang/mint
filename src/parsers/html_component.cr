module Mint
  class Parser
    def html_component : Ast::HtmlComponent?
      start do |start_position|
        component = start do
          next unless char! '<'
          type_id
        end

        next unless component
        whitespace
        if keyword "as"
          whitespace

          next error :html_component_expected_reference do
            expected "the reference of the HTML component", word
            snippet self
          end unless ref = variable
        end

        attributes, children, comments, closing_tag_position =
          html_body(
            with_dashes: false,
            tag: component,
            expected_closing_bracket: ->{
              error :html_component_expected_closing_bracket do
                expected "the closing bracket of a HTML component", word
                snippet self
              end
            },
            expected_closing_tag: ->{
              error :html_component_expected_closing_tag do
                expected "the closing tag of a HTML component", word
                snippet self
              end
            })

        node = self << Ast::HtmlComponent.new(
          closing_tag_position: closing_tag_position,
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
