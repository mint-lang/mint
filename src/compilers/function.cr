module Mint
  class Compiler
    def compile(node : Ast::Function, contents = "") : String
      if checked.includes?(node)
        _compile node, contents
      else
        ""
      end
    end

    def _compile(node : Ast::Function, contents = "") : String
      name =
        js.variable_of(node)

      expression =
        compile node.body

      wheres =
        compile node.where.try(&.statements) || [] of Ast::WhereStatement

      arguments =
        compile node.arguments

      last =
        [js.return(expression)]

      last.unshift(contents) unless contents.empty?

      body =
        js.statements(wheres + last)

      js.function(name, arguments, body)
    end
  end
end
