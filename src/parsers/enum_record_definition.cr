module Mint
  class Parser
    def enum_record_definition
      start do |start_position|
        fields =
          list(
            terminator: ')',
            separator: ','
          ) { record_definition_field }

        next if fields.empty?

        Ast::EnumRecordDefinition.new(
          from: start_position,
          fields: fields,
          to: position,
          input: data)
      end
    rescue error : Error
      nil
    end
  end
end
