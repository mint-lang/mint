module Mint
  class Compiler
    def _compile(node : Ast::WhereStatement) : String
      expression =
        compile node.expression

      if node.variables.size > 1
        variables =
          node
            .variables
            .map { |param| js.variable_of(param) }
            .join(",")

        "const [#{variables}] = #{expression}"
      elsif node.variables.size == 1
        name =
          js.variable_of(node.variables[0])

        "let #{name} = #{expression}"
      else
        ""
      end
    end
  end
end
