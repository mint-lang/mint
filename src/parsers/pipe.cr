module Mint
  class Parser
    syntax_error PipeExpectedCall

    # This method rolls an operation where the operator is "|>" into a single
    # call. Every other operation is passed trough.
    def rollup_pipe(operation) : Ast::Pipe | Ast::Operation
      return operation unless operation.operator == "|>"

      expression = operation.right
      argument = operation.left

      argument =
        case argument
        when Ast::Operation
          rollup_pipe(argument)
        else
          argument
        end

      Ast::Pipe.new(
        expression: expression,
        argument: argument,

        from: argument.from,
        to: expression.to,
        input: data)
    end
  end
end
