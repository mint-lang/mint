module Mint
  class Compiler2
    def compile(node : Ast::Route) : Compiled
      expression =
        compile node.expression

      arguments =
        compile node.arguments

      mapping =
        node
          .arguments
          .map { |argument| ["'#{argument.name.value}'"] of Item }

      decoders =
        node
          .arguments
          .map { |argument| decoder(cache[argument]) }

      handler =
        if async?(node.expression)
          js.async_arrow_function(arguments) { expression }
        else
          js.arrow_function(arguments) { expression }
        end

      js.object({
        "handler"  => handler,
        "decoders" => js.array(decoders),
        "mapping"  => js.array(mapping),
        "path"     => ["`#{node.url}`"] of Item,
      })
    end
  end
end
