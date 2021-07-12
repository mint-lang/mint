module Mint
  class Compiler
    def compile(node : Ast::Function, contents = "") : String
      if checked.includes?(node)
        _compile node, contents
      else
        ""
      end
    end

    def _compile(node : Ast::Block) : String
      if node.statements.size == 1
        compile node.statements.first
      else
        compiled_statements =
          compile(
            node
              .statements
              .sort_by! { |item| resolve_order.index(item) || -1 })

        last =
          compiled_statements.pop

        js.iif do
          js.statements(compiled_statements + [js.return(last)])
        end
      end
    end

    def _compile(node : Ast::Function, contents = "") : String
      name =
        js.variable_of(node)

      expression =
        compile node.body

      wheres =
        node.where
          .try(&.statements)
          .try(&.sort_by { |item| resolve_order.index(item) || -1 })
          .try { |statements| compile statements }

      arguments =
        compile node.arguments

      last =
        [js.return(expression)]

      last.unshift(contents) unless contents.empty?

      body =
        js.statements(%w[] &+ wheres &+ last)

      js.function(name, arguments, body)
    end
  end
end
