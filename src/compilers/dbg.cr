module Mint
  class Compiler
    def compile(node : Ast::Dbg) : Compiled
      compile node do
        location =
          js.string("#{node.file.path}:#{node.location.start[0]}:#{node.location.start[1]}")

        var =
          [Variable.new] of Item

        if expression = node.expression
          js.iif do
            js.statements([
              js.const(var, compile(expression)),
              js.call(["console.log"] of Item, [location]),
              js.call(["console.log"] of Item, [var]),
              js.return(var),
            ])
          end
        else
          js.arrow_function([var]) do
            js.statements([
              js.call(["console.log"] of Item, [location]),
              js.call(["console.log"] of Item, [var]),
              js.return(var),
            ])
          end
        end
      end
    end
  end
end
