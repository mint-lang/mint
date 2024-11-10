module Mint
  class Compiler
    def resolve(node : Ast::Function)
      resolve node do
        {node, node, compile_function(node, contents: nil, args: nil, skip_const: true)}
      end
    end

    def compile_function(node : Ast::Function)
      compile node do
        compile(node, contents: nil, args: nil)
      end
    end

    def compile_function(
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
        [
          SourceMapped.new(
            value: js.arrow_function(arguments) { js.statements(items) },
            node: node),
        ] of Item

      if skip_const
        body
      else
        js.const(node, body)
      end
    end
  end
end
