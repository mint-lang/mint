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
          .map { |argument| @serializer.decoder(cache[argument]) }

      handler =
        if async?(node.expression)
          js.async_arrow_function(arguments, expression)
        else
          js.arrow_function(arguments, expression)
        end

      js.object({
        "handler"  => handler,
        "decoders" => js.array(decoders),
        "mapping"  => js.array(mapping),
        "path"     => "`#{node.url}`",
      })
    end

    def _compile_service_worker(node : Ast::Route) : String
      "'#{node.url}'"
    end
  end
end
