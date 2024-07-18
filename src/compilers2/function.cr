module Mint
  class Compiler2
    def resolve(node : Ast::Function)
      resolve node do
        {node, node, compile(node, contents: nil, args: nil, skip_const: true)}
      end
    end

    def compile(node : Ast::Function)
      compile node do
        compile(node, contents: nil, args: nil)
      end
    end

    def compile(
      node : Ast::Function, *,
      contents : Compiled | Nil = nil,
      args : Array(Compiled) | Nil = nil,
      skip_const : Bool = false
    ) : Compiled
      items =
        [] of Compiled

      arguments =
        args || compile(node.arguments)

      items << contents if contents
      items << compile(node.body, for_function: true)

      body =
        if async?(node.body.expressions)
          js.async_arrow_function(arguments) { js.statements(items) }
        else
          js.arrow_function(arguments) { js.statements(items) }
        end

      if skip_const
        body
      else
        js.const(node, body)
      end
    end
  end
end
