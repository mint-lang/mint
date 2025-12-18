module Mint
  class Compiler
    def compile(node : Ast::Call) : Compiled
      compile node do
        expression =
          compile node.expression

        captures =
          [] of Compiled

        args =
          artifacts.call_arguments[node].dup

        while args.size > 0 && args.last.nil?
          args.pop
        end

        arguments =
          args.map do |item|
            next ["undefined"] unless item

            case item.value
            when Ast::Discard
              [Variable.new.as(Item)].tap { |var| captures << var }
            else
              compile item
            end
          end

        receiver =
          case
          when node.expression.is_a?(Ast::InlineFunction)
            ["("] + expression + [")"]
          else
            expression
          end

        call =
          js.call(receiver, arguments)

        if captures.size > 0
          ["("] + js.arrow_function(captures) { js.return(call) } + [")"]
        else
          call
        end
      end
    end
  end
end
