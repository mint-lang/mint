module Mint
  class Parser
    def html_style : Ast::HtmlStyle?
      parse do |start_position|
        next unless word! "::"
        next unless name = variable track: false, extra_chars: ['-']

        arguments = [] of Ast::Field

        if char! '('
          whitespace
          arguments = list(
            terminator: ')',
            separator: ','
          ) { field(key_required: false) }

          whitespace
          next error :html_style_expected_closing_parenthesis do
            expected "the closing parenthesis of a style call", word
            snippet self
          end unless char! ')'
        end

        Ast::HtmlStyle.new(
          arguments: arguments,
          from: start_position,
          to: position,
          file: file,
          name: name)
      end
    end
  end
end
