module Mint
  class Parser
    def html_style : Ast::HtmlStyle?
      parse do |start_position|
        next unless word! "::"
        next unless name = variable track: false, extra_chars: ['-']

        arguments = [] of Ast::Node

        if char! '('
          whitespace
          arguments = list(terminator: ')', separator: ',') { expression }

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
