module Mint
  class Compiler
    def _compile(node : Ast::Get) : String
      body =
        compile node.body

      wheres =
        node.where
          .try(&.statements)
          .try(&.sort_by { |item| resolve_order.index(item) || -1 })
          .try { |statements| compile statements }

      name =
        js.variable_of(node)

      last =
        [js.return(body)]

      body =
        js.statements(%w[] &+ wheres &+ last)

      js.get(name, body)
    end
  end
end
