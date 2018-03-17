class Parser
  syntax_error AccessExpectedVariable

  def access : Ast::Access | Nil
    start do |start_position|
      base = start do
        value = variable
        skip unless char == '.'
        value
      end

      skip unless base

      fields = many do
        next unless char! '.'
        variable! AccessExpectedVariable
      end

      Ast::Access.new(
        fields: ([base] + fields).compact,
        from: start_position,
        to: position,
        input: data)
    end
  end
end
