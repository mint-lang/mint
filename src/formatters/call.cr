module Mint
  class Formatter
    def format(node : Ast::Call) : Nodes
      arguments, block =
        if last = node.arguments.last?
          case last.value
          when Ast::BlockFunction
            {node.arguments[0..-2], [" "] + format(last)}
          end
        end || {node.arguments, [] of Node}

      format(node.expression) + format_arguments(arguments) + block
    end
  end
end
