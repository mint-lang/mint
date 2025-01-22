module Mint
  class Parser
    def html_element : Ast::HtmlElement?
      parse do |start_position|
        next unless char! '<'
        next unless tag = variable track: false, extra_chars: ['-']

        styles = [] of Ast::HtmlStyle

        if word? "::"
          styles = many(parse_whitespace: false) { html_style }

          # We need to consume the double colon for the error.
          word! "::"

          next error :html_element_expected_style do
            expected "the style for an HTML element", word
            snippet self
          end if styles.empty?
        end

        whitespace

        ref =
          parse do
            next unless keyword! "as"
            next unless whitespace!

            next error :html_element_expected_reference do
              expected "the reference of an HTML element", word
              snippet self
            end unless value = variable

            value
          end

        body =
          html_body(
            with_dashes: true,
            tag: tag,
            expected_closing_bracket: -> {
              error :html_element_expected_closing_bracket do
                expected "the closing bracket of an HTML element", word
                snippet self
              end
            },
            expected_closing_tag: -> {
              error :html_element_expected_closing_tag do
                expected "the closing tag of an HTML element", word
                snippet self
              end
            })

        next unless body

        attributes, children, comments, closing_tag_position = body

        Ast::HtmlElement.new(
          closing_tag_position: closing_tag_position,
          attributes: attributes,
          from: start_position,
          children: children,
          comments: comments,
          styles: styles,
          to: position,
          file: file,
          tag: tag,
          ref: ref)
      end
    end
  end
end
