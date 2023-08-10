module Mint
  class Parser
    def enum_option
      start do |start_position|
        comment = self.comment

        next unless value = type_id
        whitespace

        parameters = [] of Ast::TypeVariable | Ast::Type

        if char! '('
          whitespace

          parameters.concat list(
            terminator: ')',
            separator: ','
          ) { enum_record_definition || type_variable || type }

          whitespace
          next error :enum_option_expected_closing_parenthesis do
            expected "the closing parenthesis of an enum option", word
            snippet self
          end unless char! ')'
        end

        self << Ast::EnumOption.new(
          parameters: parameters,
          from: start_position,
          comment: comment,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
