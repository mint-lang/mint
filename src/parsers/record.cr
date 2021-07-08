module Mint
  class Parser
    def record : Ast::Record?
      start do |start_position|
        next unless char! '{'

        fields = [] of Ast::RecordField

        unless char! '}'
          whitespace

          fields = list(terminator: '}', separator: ',') { record_field }

          whitespace
          next unless char! '}'
        end

        self << Ast::Record.new(
          from: start_position,
          fields: fields,
          to: position,
          input: data)
      end
    end
  end
end
