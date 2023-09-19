module Mint
  class Parser
    def type : Ast::Type?
      parse do |start_position|
        next unless name = id

        if char! '('
          parameters = list(separator: ',', terminator: ')') do
            whitespace
            type = self.type || type_variable

            whitespace
            next error :type_expected_type_or_type_variable do
              expected "a type or a type variable", word
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

        Ast::Type.new(
          parameters: parameters,
          from: start_position,
          to: position,
          file: file,
          name: name)
      end
    end
  end
end
