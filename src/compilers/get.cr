module Mint
  class Compiler
    def _compile(node : Ast::Get) : String
      body =
        compile node.body

      wheres =
        compile(
          (node.where.try(&.statements) || [] of Ast::WhereStatement)
            .sort_by { |node| resolve_order.index(node) || -1 })

      name =
        js.variable_of(node)

      body =
        js.statements(wheres + [js.return(body)])

      js.get(name, body)
    end
  end
end
