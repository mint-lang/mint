module Mint
  class Compiler
    def compile(node : Ast::Dbg) : Compiled
      compile node do
        location =
          js.string("#{node.file.relative_path_posix}:#{node.from.line}:#{node.from.column}")

        var =
          [Variable.new] of Item

        arg =
          if node.bang?
            var
          else
            js.call(Builtin::Inspect, [var])
          end

        location =
          if config.generate_source_maps
            [] of Item
          else
            js.call(["console.log"] of Item, [location])
          end

        if expression = node.expression
          js.iif do
            js.statements([
              js.const(var, compile(expression)),
              location,
              js.call(["console.log"] of Item, [arg]),
              js.return(var),
            ])
          end
        else
          js.arrow_function([var]) do
            js.statements([
              location,
              js.call(["console.log"] of Item, [arg]),
              js.return(var),
            ])
          end
        end
      end
    end
  end
end
