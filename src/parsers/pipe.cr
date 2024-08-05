module Mint
  class Parser
    # This method rolls up an operation where the operator is "|>" into a
    # single call. Every other operation is passed trough.
    def pipe(operation : Ast::Operation) : Ast::Pipe | Ast::Operation?
      return operation unless operation.operator == "|>"

      expression = operation.right
      argument = operation.left

      argument =
        case argument
        when Ast::Operation
          pipe(argument)
        else
          argument
        end

      Ast::Pipe.new(
        expression: expression,
        from: argument.from,
        argument: argument,
        to: expression.to,
        file: file)
    end

    def pipe(operation : Nil) : Ast::Pipe | Ast::Operation?
      nil
    end
  end
end
