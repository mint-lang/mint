module Mint
  class Parser
    def html_attribute(with_dashes : Bool = true) : Ast::HtmlAttribute?
      parse do |start_position|
        # Dash (-) is maily for data attributes (data-value), colon (`:`) is
        # for namespaces (xlink:actuate) and we only parse them for HTML
        # attributes not component attributes (`with_dashes`).
        name = variable track: false, extra_chars: with_dashes ? ['-', ':'] : [] of Char
        next unless name

        next error :html_attribute_expected_equal_sign do
          expected "the equal sign of an HTML attribute", word
          snippet self
        end unless char! '='

        value =
          html_fragment ||
            string_literal ||
            array_literal ||
            block(
              ->{ error :html_attribute_expected_opening_bracket do
                expected "the opening bracket of an HTML attribute", word
                snippet self
              end },
              ->{ error :html_attribute_expected_closing_bracket do
                expected "the closing bracket of an HTML attribute", word
                snippet self
              end },
              ->{ error :html_attribute_expected_expression do
                expected "the expression of an HTML attribute", word
                snippet self
              end })

        next unless value

        Ast::HtmlAttribute.new(
          from: start_position,
          to: position,
          value: value,
          file: file,
          name: name)
      end
    end
  end
end
