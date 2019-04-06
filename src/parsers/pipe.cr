module Mint
  class Parser
    syntax_error PipeExpectedCall

    # This method rolls an operation where the operator is "|>" into a single
    # call. Every other operation is passed trough.
    def rollup_pipe(operation) : Ast::Call | Ast::Operation
      return operation unless operation.operator == "|>"

      right = operation.right
      left = operation.left

      left =
        case left
        when Ast::Operation
          rollup_pipe(left)
        else
          left
        end

      case right
      when Ast::Call
        right.arguments << left
        right.piped = true
      else
        raise PipeExpectedCall, right.from
      end

      right
    end
  end
end
