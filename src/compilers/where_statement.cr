module Mint
  class Compiler
    def _compile(node : Ast::WhereStatement) : Codegen::Node
      expression =
        compile node.expression

      case target = node.target
      when Ast::Variable
        name =
          Codegen.symbol_mapped(target, js.variable_of(target))

        Codegen.join ["let ", name, " = ", expression]
      when Ast::TupleDestructuring
        Codegen.join ["const ", _to_variable(target), " = ", expression]
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
