module Mint
  class Compiler
    def compile(node : Ast::Test) : Compiled
      compile node do
        location =
          [
            Raw.new({
              start:    {node.from.line, node.from.column},
              end:      {node.to.line, node.to.column},
              filename: node.file.relative_path,
            }.to_json),
          ]

        name =
          compile node.name

        refs =
          js.consts(node.refs.to_h.keys.map do |ref|
            {node, ref, js.call(Builtin::Signal, [js.new(nothing, [] of Compiled)])}
          end)

        expression =
          case operation = node.expression
          when Ast::Operation
            if (operator = operation.operator).in?("==", "!=")
              right =
                compile operation.right

              left =
                compile operation.left

              js.call(
                Builtin::TestOperation,
                [left, right, [operator] of (Item)])
            end
          end || compile(node.expression)

        js.object({
          "proc"     => js.arrow_function { js.statements([refs, js.return(expression)]) },
          "location" => location,
          "name"     => name,
        })
      end
    end
  end
end
