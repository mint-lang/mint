module Mint
  class Compiler
    def compile(node : Ast::Statement, last : Bool) : String
      if checked.includes?(node)
        _compile(node, last)
      else
        ""
      end
    end

    def _compile(node : Ast::Statement, last : Bool) : String
      right = compile node.expression
      right = "await #{right}" if node.await

      if (target = node.target) && !last
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
