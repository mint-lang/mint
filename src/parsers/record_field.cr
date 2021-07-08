module Mint
  class Parser
    def record_field : Ast::RecordField?
      start do |start_position|
        comment = self.comment

        next unless key = variable
        whitespace

        next unless char! '='
        whitespace

        next unless value = expression

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
