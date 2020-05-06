module Mint
  class Compiler
    def _compile(node : Ast::EnumDestructuring, variable, index : Int32? = nil) : {Array(String), String}
      name =
        js.class_of(lookups[node])

      condition_var_name = !index ? variable : "#{variable}._#{index}"
      condition = "#{condition_var_name} instanceof #{name}"

      variables = node.parameters.map_with_index do |param, index1|
        var_name = js.variable_of(param)
        vars = ["const #{var_name} = #{variable}._#{index1}"]

        if param.is_a? Ast::DestructuringType
          res = case param
                when Ast::ArrayDestructuring
                  _compile param, var_name, index1
                when Ast::TupleDestructuring
                  _compile param, var_name, index1
                when Ast::EnumDestructuring
                  _compile param, var_name, index1
                else
                  puts param.class
                  # ignore
                end.not_nil!

          condition += " && " + res[1]
          vars.concat(res[0])
        end

        vars
      end.flatten

      {variables, condition}
    end
  end
end
