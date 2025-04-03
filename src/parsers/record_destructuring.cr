module Mint
  class Parser
    def record_destructuring : Ast::RecordDestructuring?
      parse do |start_position|
        next unless char! '{'

        fields = [] of Ast::Field

        unless char! '}'
          whitespace

          fields =
            list(terminator: '}', separator: ',') do
              field(destructuring: true, key_required: true)
            end

          whitespace
          next unless char! '}'
        end

        Ast::RecordDestructuring.new(
          from: start_position,
          fields: fields,
          to: position,
          file: file)
      end
    end
  end
end
