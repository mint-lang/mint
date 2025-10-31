module Mint
  class Compiler
    def compile(node : Ast::Statement) : Compiled
      compile node do
        right =
          compile(node.expression)

        if target = node.target
          case target
          when Ast::Variable
            js.const(target, right)
          when Ast::RecordDestructuring,
               Ast::TupleDestructuring,
               Ast::ArrayDestructuring,
               Ast::TypeDestructuring,
               Ast::Discard
            variables = [] of Compiled

            pattern =
              destructuring(target, variables)

            case target
            when Ast::TupleDestructuring
              if target.items.all?(Ast::Variable)
                js.const(js.array(variables), right)
              end
            end || begin
              var =
                Variable.new

              const =
                js.const(var, js.call(Builtin::Destructure, [right, pattern]))

              return_value =
                if ret = node.return_value
                  compile(ret)
                else
                  case parent = node.parent
                  when Ast::Block
                    if fallback = parent.fallback
                      if fallback_variable = @fallbacks[fallback]?
                        js.call(fallback_variable, [] of Compiled)
                      end
                    end
                  end
                end

              return_if =
                if return_value
                  js.if([var, " === false"], js.return(return_value))
                end

              js.statements([
                const,
                return_if,
                js.const(js.array(variables), [var]),
              ].compact)
            end
          end
        end || right
      end
    end
  end
end
