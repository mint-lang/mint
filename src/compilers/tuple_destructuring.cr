module Mint
  class Compiler
    def _compile(node : Ast::TupleDestructuring, variable : String) : Tuple(String, Array(String))
      variables =
        node
          .parameters
          .join(',') { |param| js.variable_of(param) }

      {
        "Array.isArray(#{variable})",
        ["const [#{variables}] = #{variable}"],
      }
    end
  end
end
