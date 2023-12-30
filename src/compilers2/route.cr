module Mint
  class Compiler2
    def compile(node : Ast::Route) : Compiled
      compile node do
        expression =
          compile node.expression

        arguments =
          compile node.arguments

        mapping =
          node
            .arguments
            .map { |argument| js.string(argument.name.value) }

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
          "path"     => js.string(node.url),
          "decoders" => js.array(decoders),
          "mapping"  => js.array(mapping),
          "handler"  => handler,
        })
      end
    end
  end
end
