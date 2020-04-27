module Mint
  class Parser
    syntax_error RecordUpdateExpectedClosingBracket
    syntax_error RecordUpdateExpectedFields

    def record_update : Ast::RecordUpdate?
      start do |start_position|
        variable = start do
          char '{', SkipError
          whitespace
          value = variable! SkipError
          whitespace
          char '|', SkipError
          value
        end

        skip unless variable

        whitespace

        fields = list(
          terminator: '}',
          separator: ','
        ) { record_field.as(Ast::RecordField?) }.compact

        raise RecordUpdateExpectedFields if fields.empty?

        whitespace

        char '}', RecordUpdateExpectedClosingBracket

        Ast::RecordUpdate.new(
          from: start_position,
          variable: variable,
          fields: fields,
          to: position,
          input: data)
      end
    end
  end
end
