module Mint
  class Parser
    def call(expression : Ast::Node) : Ast::Call?
      parse do
        next unless char! '('
        whitespace

        arguments = list(
          terminator: ')',
          separator: ','
        ) { field(key_required: false, discard: true) }

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

        block = parse do
          whitespace
          block_function
        end

        if block
          arguments.push(
            Ast::Field.new(
              from: block.from,
              file: block.file,
              to: block.to,
              comment: nil,
              value: block,
              key: nil,
            ))
        end

        Ast::Call.new(
          expression: expression,
          from: expression.from,
          arguments: arguments,
          await: false,
          to: position,
          file: file)
      end
    end
  end
end
