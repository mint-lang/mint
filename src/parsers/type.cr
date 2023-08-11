module Mint
  class Parser
    def type : Ast::Type?
      start do |start_position|
        next unless name = type_id

        if char! '('
          parameters = list(separator: ',', terminator: ')') do
            whitespace
            type =
              self.type.as(Ast::Type?) ||
                type_variable.as(Ast::TypeVariable?)

            whitespace
            next error :type_expected_type_or_type_variable do
              expected "the type of a type field", word
              snippet self
            end unless type

            type
          end

          next error :type_expected_closing_parenthesis do
            expected "the closing parenthesis of a type", word
            snippet self
          end unless char! ')'
        else
          parameters = [] of Ast::Type | Ast::TypeVariable
        end

        self << Ast::Type.new(
          parameters: parameters,
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
