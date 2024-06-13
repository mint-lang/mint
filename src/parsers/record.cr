module Mint
  class Parser
    def record(*, skip_empty : Bool = true) : Ast::Record?
      parse do |start_position|
        next unless char! '{'

        fields = [] of Ast::Field

        unless char! '}'
          whitespace
          fields = list(terminator: '}', separator: ',') { field }
          whitespace

          next unless char! '}'
        end

        next if skip_empty && fields.empty?

        Ast::Record.new(
          from: start_position,
          fields: fields,
          to: position,
          file: file)
      end
    end
  end
end
