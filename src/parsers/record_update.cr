module Mint
  class Parser
    syntax_error RecordUpdateExpectedClosingBracket
    syntax_error RecordUpdateExpectedFields

    def record_update : Ast::RecordUpdate?
      start do |start_position|
        expression = start do
          next unless char! '{'

          whitespace
          value = variable(track: false) || self.expression
          whitespace

          next unless value
          next if keyword_ahead?("|>") # Skip if tuple with a pipe `{ x |> Number.toString }`
          next unless char! '|'

          self << value
        end

        next unless expression

        whitespace

        fields = list(
          terminator: '}',
          separator: ','
        ) { record_field.as(Ast::RecordField?) }

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
