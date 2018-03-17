class Parser
  syntax_error NextCallExpectedRecord

  def next_call : Ast::NextCall | Nil
    start do |start_position|
      skip unless keyword "next"

      whitespace! SkipError

      item = record_update || record || variable

      raise NextCallExpectedRecord unless item

      Ast::NextCall.new(
        from: start_position,
        to: position,
        input: data,
        data: item)
    end
  end
end
