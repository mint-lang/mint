module Mint
  class Compiler2
    def resolve(node : Ast::Get)
      resolve node do
        body =
          compile node.body, for_function: true

        body =
          js.arrow_function([] of Compiled) { body }

        {node, node, body}
      end
    end
  end
end
