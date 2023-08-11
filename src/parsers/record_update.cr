module Mint
  class Parser
    def record_update : Ast::RecordUpdate?
      start do |start_position|
        expression = start do
          next unless char! '{'

          whitespace
          value = variable || self.expression
          whitespace

          next unless value
          next if keyword_ahead?("|>") # Skip if tuple with a pipe `{ x |> Number.toString }`
          next unless char! '|'

          value
        end

        next unless expression

        whitespace

        fields = list(
          terminator: '}',
          separator: ','
        ) { record_field.as(Ast::RecordField?) }

        next error :record_update_expected_fields do
          expected "the fields for a record update", word
          snippet self
        end if fields.empty?

        whitespace

        next error :record_update_expected_closing_bracket do
          expected "the closing bracket of a record update", word
          snippet self
        end unless char! '}'

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
