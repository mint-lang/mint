module Mint
  class Parser
    def function : Ast::Function?
      parse do |start_position|
        comment = self.comment
        whitespace

        next unless keyword! "fun"
        whitespace

        next error :function_expected_name do
          expected "the name of the function", word
          snippet self
        end unless name = variable track: false
        whitespace

        arguments =
          if char! '('
            whitespace
            items = list(terminator: ')', separator: ',') { argument }
            whitespace

            next error :function_expected_closing_parenthesis do
              expected "the closing parenthesis of a function", word
              snippet self
            end unless char! ')'
            whitespace

            items
          end || [] of Ast::Argument

        type =
          if char! ':'
            whitespace
            next error :function_expected_type_or_variable do
              expected "the type of a function", word
              snippet self
            end unless item = self.type || type_variable
            whitespace

            item
          end

        body =
          block(
            ->{ error :function_expected_opening_bracket do
              expected "the opening bracket of a function", word
              snippet self
            end },
            ->{ error :function_expected_closing_bracket do
              expected "the closing bracket of a function", word
              snippet self
            end },
            ->{ error :function_expected_expression do
              expected "the body of a function", word
              snippet self
            end })

        next unless body

        Ast::Function.new(
          arguments: arguments,
          from: start_position,
          comment: comment,
          to: position,
          file: file,
          body: body,
          name: name,
          type: type)
      end
    end
  end
end
