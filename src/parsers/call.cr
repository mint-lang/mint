module Mint
  class Parser
    def call(expression : Ast::Node) : Ast::Call?
      parse do
        next unless char! '('
        whitespace

        arguments = list(
          terminator: ')',
          separator: ','
        ) { field(key_required: false) }

        whitespace
        next error :call_expected_closing_parenthesis do
          block do
            text "The"
            bold "arguments"
            text "of a"
            bold "call"
            text "must be enclosed by parenthesis, here is an example:"
          end

          snippet %(greet("Joe"))
          expected "the closing parenthesis of a call", word
          snippet self
        end unless char! ')'

        Ast::Call.new(
          expression: expression,
          from: expression.from,
          arguments: arguments,
          to: position,
          file: file)
      end
    end
  end
end
