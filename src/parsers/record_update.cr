module Mint
  class Parser
    syntax_error RecordUpdateExpectedClosingBracket
    syntax_error RecordUpdateExpectedFields

    def record_update : Ast::RecordUpdate?
      start do |start_position|
        expression = start do
          char '{', SkipError

          whitespace
          value = variable || self.expression
          whitespace

          skip unless value

          char '|', SkipError
          value
        end

        skip unless expression

        whitespace

        fields = list(
          terminator: '}',
          separator: ','
        ) { record_field.as(Ast::RecordField?) }.compact

        raise RecordUpdateExpectedFields if fields.empty?

        whitespace

        char '}', RecordUpdateExpectedClosingBracket

        self << Ast::RecordUpdate.new(
          expression: expression,
          from: start_position,
          fields: fields,
          to: position,
          input: data)
      end
    end
  end
end
