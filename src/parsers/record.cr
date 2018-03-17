class Parser
  syntax_error RecordExpectedClosingBracket

  def record : Ast::Record | Nil
    start do |start_position|
      skip unless char! '{'

      fields = [] of Ast::RecordField

      unless char! '}'
        whitespace

        fields.concat(
          list(
            terminator: '}',
            separator: ','
          ) { record_field }.compact)

        whitespace
        char '}', RecordExpectedClosingBracket
      end

      Ast::Record.new(
        from: start_position,
        fields: fields,
        to: position,
        input: data)
    end
  end
end
