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

      decoders =
        node
          .arguments
          .map { |argument| @decoder.generate(cache[argument]) }

      js.object({
        "handler"  => js.arrow_function(arguments, expression),
        "decoders" => js.array(decoders),
        "mapping"  => js.array(mapping),
        "path"     => "`#{node.url}`",
      })
    end
  end
end
