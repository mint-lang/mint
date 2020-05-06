module Mint
  class Compiler
    def _compile(node : Ast::EnumDestructuring, variable : String, condition_variable : String? = nil)
      name =
        js.class_of(lookups[node])

      condition_var_name = condition_variable || variable
      condition = "#{condition_var_name} instanceof #{name}"

      variables = node.parameters.map_with_index do |param, index1|
        var_name = js.variable_of(param)
        vars = ["const #{var_name} = #{variable}._#{index1}"]

        res = _compile_destructuring param, var_name, "#{condition_var_name}._#{index1}"

        if res
          condition += " && " + res[1]
          vars.concat(res[0])
        end

        vars
      end.flatten

      {variables, condition}
    end
  end
end
