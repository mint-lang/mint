module Mint
  class Compiler
    def _compile(node : Ast::Route) : String
      expression =
        compile node.expression

      arguments =
        compile node.arguments

      mapping =
        node
          .arguments
          .map { |argument| "'#{argument.name.value}'" }

      js.object({
        "handler" => js.arrow_function(arguments, expression),
        "mapping" => js.array(mapping),
        "path"    => "`#{node.url}`",
      })
    end
  end
end
