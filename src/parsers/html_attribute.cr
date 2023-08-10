module Mint
  class Parser
    def html_attribute(with_dashes : Bool = true, fixed_name : String? = nil) : Ast::HtmlAttribute?
      start do |start_position|
        name = with_dashes ? variable_attribute_name : variable(track: false)

        next unless name
        next if fixed_name && name.value != fixed_name

        next error :html_attribute_expected_equal_sign do
          expected "the equal sign of an HTML attribute", word
          snippet self
        end unless char! '='

        case
        when keyword_ahead?("<{") && (value = html_expression)
          value
        when char == '"' && (value = string_literal)
          value
        when char == '[' && (value = array)
          value
        else
          value = code_block2(
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
        end

        self << Ast::HtmlAttribute.new(
          value: value.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
