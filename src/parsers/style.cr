module Mint
  class Parser
    def style : Ast::Style?
      parse do |start_position|
        next unless keyword! "style"
        whitespace

        next error :style_expected_name do
          expected "the name of a style", word
          snippet self
        end unless name = variable extra_chars: ['-']
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
          whitespace
        end

        body =
          brackets(
            ->{ error :style_expected_opening_bracket do
              expected "the opening bracket of a style", word
              snippet self
            end },
            ->{ error :style_expected_closing_bracket do
              expected "the closing bracket of a style", word
              snippet self
            end },
            ->(items : Array(Ast::Node)) {
              error :style_expected_body do
                expected "the body of a style", word
                snippet self
              end if items.empty?
            }) { many { css_keyframes || css_font_face || css_node } }

        next unless body

        Ast::Style.new(
          from: start_position,
          arguments: arguments,
          to: position,
          file: file,
          body: body,
          name: name)
      end
    end
  end
end
