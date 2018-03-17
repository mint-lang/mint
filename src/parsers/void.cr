class Parser
  def void : Ast::Void | Nil
    start do |start_position|
      skip unless keyword "void"

      Ast::Void.new(
        from: start_position,
        to: position,
        input: data)
    end
  end
end
