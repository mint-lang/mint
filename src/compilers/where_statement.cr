module Mint
  class Compiler
    def _compile(node : Ast::WhereStatement) : String
      name =
        js.variable_of(node)

      expression =
        compile node.expression

      "let #{name} = #{expression}"
    end
  end
end
