class Parser
  syntax_error ModuleCallExpectedClosingParentheses
  syntax_error ModuleCallExpectedFunction

  def module_call : Ast::ModuleCall | Nil
    start do |start_position|
      name = start do
        value = type_id
        skip unless char! '.'
        value
      end

      skip unless name
      function = variable! ModuleCallExpectedFunction
      skip unless char! '('

      whitespace
      arguments = list(
        terminator: ')',
        separator: ','
      ) { expression.as(Ast::Expression | Nil) }.compact
      whitespace

      char ')', ModuleCallExpectedClosingParentheses

      Ast::ModuleCall.new(
        arguments: arguments,
        from: start_position,
        function: function,
        to: position,
        piped: false,
        input: data,
        name: name)
    end
  end
end
