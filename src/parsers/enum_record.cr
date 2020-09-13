module Mint
  class Parser
    def enum_record : Ast::EnumRecord?
      start do |start_position|
        fields =
          list(
            terminator: ')',
            separator: ','
          ) { record_field }.compact

        skip if fields.empty?

        Ast::EnumRecord.new(
          from: start_position,
          fields: fields,
          to: position,
          input: data)
      end
    rescue error : SyntaxError
      nil
    end
  end
end
