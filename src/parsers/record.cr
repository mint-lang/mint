module Mint
  class Parser
    def record : Ast::Record?
      parse do |start_position|
        next unless char! '{'

        fields = [] of Ast::Field

        unless char! '}'
          whitespace
          fields = list(terminator: '}', separator: ',') { field }
          whitespace

          next unless char! '}'
        end

        Ast::Record.new(
          from: start_position,
          fields: fields,
          to: position,
          file: file)
      end
    end
  end
end
