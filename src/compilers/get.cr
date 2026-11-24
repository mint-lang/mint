module Mint
  class Compiler
    def resolve(node : Ast::Get)
      resolve node do
        body =
          compile node.body, for_function: true

        body =
          js.arrow_function(hidden_parameters(node)) { body }

        {node, node, body}
      end
    end
  end
end
