module Mint
  class Compiler
    def _compile(node : Ast::Statement) : String
      right = compile node.expression
      right = "await #{right}" if node.await

      if node.parent == Ast::Statement::Parent::None && (target = node.target)
        case target
        when Ast::Variable
          js.const(js.variable_of(target), right)
        when Ast::TupleDestructuring
          variables =
            target
              .parameters
              .join(',') { |param| js.variable_of(param) }

          "const [#{variables}] = #{right}"
        else
          right
        end
      else
        right
      end
    end
  end
end
