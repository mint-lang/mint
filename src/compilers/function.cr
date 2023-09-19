module Mint
  class Compiler
    def compile(node : Ast::Function, contents = "") : String
      node.in?(checked) ? _compile(node, contents) : ""
    end

    def _compile(node : Ast::Function, contents = "") : String
      name =
        js.variable_of(node)

      items =
        [] of String

      arguments =
        compile node.arguments

      items << contents unless contents.empty?
      items << compile(node.body, for_function: true)

      body =
        js.statements(items)

      if async?(node.body)
        js.async_function(name, arguments, body)
      else
        js.function(name, arguments, body)
      end
    end
  end
end
