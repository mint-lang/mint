module Mint
  class Parser
    def type_variant : Ast::TypeVariant?
      parse do |start_position|
        comment = self.comment

        next unless value = id
        whitespace

        parameters =
          if char! '('
            whitespace

            items =
              list(terminator: ')', separator: ',') do
                type_definition_field(raise_on_colon: false) ||
                  type_variable ||
                  type
              end

            whitespace
            next error :type_variant_expected_closing_parenthesis do
              expected "the closing parenthesis of an type variant", word
              snippet self
            end unless char! ')'

            items
          end || [] of Ast::Node

        Ast::TypeVariant.new(
          parameters: parameters,
          from: start_position,
          comment: comment,
          value: value,
          to: position,
          file: file)
      end
    end
  end
end
