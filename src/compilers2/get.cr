module Mint
  class Compiler2
    def resolve(node : Ast::Get)
      resolve node do
        body =
          compile node.body, for_function: true

        {node.as(Id), js.call(Builtin::Computed, [js.arrow_function { body }])}
      end
    end
  end
end
