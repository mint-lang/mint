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
        comment: operation.comment,
        expression: expression,
        from: argument.from,
        argument: argument,
        to: expression.to,
        file: file).tap do |node|
        replace(operation, node)

        expression.parent = node
        argument.parent = node
      end
    end

    def pipe(operation : Nil) : Ast::Pipe | Ast::Operation?
      nil
    end

    # Replaces a node which was parsed already with an other one: the nodes
    # which have it as their parent get the new one and the new one takes
    # its place (so the enclosing node becomes its parent).
    private def replace(old : Ast::Node, new : Ast::Node)
      return unless index = ast.nodes.rindex(&.same?(old))

      ast.nodes[index] = new

      # The nodes of the old one are before it and none of them starts
      # before it.
      (index - 1).downto(0) do |position|
        item = ast.nodes[position]
        break if item.from.offset < old.from.offset
        item.parent = new if item.parent.same?(old)
      end
    end
  end
end
