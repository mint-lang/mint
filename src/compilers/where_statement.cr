module Mint
  class Compiler
    def _compile(node : Ast::WhereStatement) : String
      expression =
        compile node.expression

      case target = node.target
      when Ast::Variable
        name =
          js.variable_of(target)

        "let #{name} = #{expression}"
      when Ast::TupleDestructuring
        variables =
          target
            .parameters
            .join(',') { |param| js.variable_of(param) }

        "const [#{variables}] = #{expression}"
      else
        ""
      end
    end
  end
end
