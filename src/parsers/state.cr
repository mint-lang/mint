class Parser
  syntax_error StateExpectedRecord
  syntax_error StateExpectedColon
  syntax_error StateExpectedType

  def state : Ast::State | Nil
    start do |start_position|
      skip unless keyword "state"

      whitespace
      char ':', StateExpectedColon
      whitespace

      type = type! StateExpectedType
      whitespace

      raise StateExpectedRecord unless state = record

      Ast::State.new(
        from: start_position,
        to: position,
        data: state,
        input: data,
        type: type)
    end
  end
end
