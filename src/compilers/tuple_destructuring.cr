module Mint
  class Compiler
    def _compile(node : Ast::TupleDestructuring, variable : String) : Tuple(String, Array(String))
      conditions = ["Array.isArray(#{variable})"]
      variables = node.parameters.map_with_index do |param, idx|
        var_name = js.variable_of(param)
        vars = ["const #{var_name} = #{variable}[#{idx}]"]

        if res = _compile_destructuring(param, "#{variable}[#{idx}]")
          conditions << res[0]
          vars.concat(res[1])
        end

        vars
      end.flatten

      {
        conditions.join(" && "),
        variables,
      }
    end
  end
end
