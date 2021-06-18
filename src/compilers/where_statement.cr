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
        "const #{_to_variable(target)} = #{expression}"
      else
        ""
      end
    end

    def _to_variable(node : Ast::TupleDestructuring)
      variables =
        node
          .parameters
          .join(',') do |param|
            case param
            when Ast::Variable, Ast::TupleDestructuring
              _to_variable(param)
            end
          end
      "[#{variables}]"
    end

    def _to_variable(node : Ast::Variable)
      js.variable_of(node)
    end
  end
end
