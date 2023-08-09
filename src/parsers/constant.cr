module Mint
  class Parser
    def constant : Ast::Constant?
      start do |start_position|
        comment = self.comment
        whitespace

        next unless keyword "const"
        whitespace

        next error :constant_expected_name do
          expected "the name of a constant", word
          snippet self
        end unless name = variable_constant
        whitespace

        next error :constant_expected_equal_sign do
          expected "the equal sign of a constant", word
          snippet self
        end unless char! '='
        whitespace

        next error :constant_expected_expression do
          expected "the expression of a constant", word
          snippet self
        end unless value = expression

        Ast::Constant.new(
          from: start_position,
          comment: comment,
          value: value,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
