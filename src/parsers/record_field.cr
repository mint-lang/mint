module Mint
  class Parser
    syntax_error RecordFieldExpectedExpression
    syntax_error RecordFieldExpectedEqualSign

    def record_field : Ast::RecordField?
      start do |start_position|
        comment = self.comment

        skip unless key = variable
        whitespace

        char '=', RecordFieldExpectedEqualSign
        whitespace

        value = expression! RecordFieldExpectedExpression

        self << Ast::RecordField.new(
          value: value,
          from: start_position,
          comment: comment,
          to: position,
          input: data,
          key: key)
      end
    end
  end
end
