class Parser
  syntax_error EnumExpectedOpeningBracket
  syntax_error EnumExpectedClosingBracket
  syntax_error EnumExpectedName

  def enum
    start do |start_position|
      return unless keyword "enum"

      whitespace
      name = type_id! EnumExpectedName

      options = block(
        opening_bracket: EnumExpectedOpeningBracket,
        closing_bracket: EnumExpectedClosingBracket
      ) do
        list(
          terminator: '}',
          separator: ','
        ) { type_id }.compact
      end

      Ast::Enum.new(
        from: start_position,
        options: options,
        to: position,
        input: data,
        name: name)
    end
  end
end
