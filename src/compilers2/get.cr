module Mint
  class Compiler2
    def resolve(node : Ast::Get)
      resolve node do
        body =
          compile node.body, for_function: true

        body =
          if async?(node.body.expressions)
            js.async_arrow_function([] of Compiled) { body }
          else
            js.arrow_function([] of Compiled) { body }
          end

        {node, node, body}
      end
    end
  end
end
