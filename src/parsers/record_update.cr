module Mint
  class Parser
    def record_update : Ast::RecordUpdate?
      parse do |start_position|
        expression = parse(track: false) do
          next unless char! '{'
          whitespace

          value = variable || self.expression
          whitespace

          next unless value
          next if word?("|>") # Skip if tuple with a pipe `{ x |> Number.toString }`
          next unless char! '|'

          value
        end

        next unless expression

        whitespace

        fields = list(
          terminator: '}',
          separator: ','
        ) { field }

        next error :record_update_expected_fields do
          expected "the fields for a record update", word
          snippet self
        end if fields.empty?

        whitespace

        next error :record_update_expected_closing_bracket do
          expected "the closing bracket of a record update", word
          snippet self
        end unless char! '}'

        Ast::RecordUpdate.new(
          expression: expression,
          from: start_position,
          fields: fields,
          to: position,
          file: file)
      end
    end
  end
end
