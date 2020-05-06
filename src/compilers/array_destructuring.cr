module Mint
  class Compiler
    private macro compile_item!(initial_var, item = item, index = index1)
      var_name = js.variable_of({{ item }})
      vars = [
        {{ initial_var }}
      ]

      res = _compile_destructuring {{ item }}, var_name, "#{condition_var_name}[#{{{ index }}}]"
      if res
        condition += " && " + res[1]
        vars.concat(res[0])
      end

      vars
    end

    def _compile(node : Ast::ArrayDestructuring, start_variable : String, condition_variable : String? = nil)
      variable = "#{start_variable}__arr"

      condition_var_name = condition_variable || start_variable
      if node.spread?
        condition = "Array.isArray(#{condition_var_name}) && #{condition_var_name}.length >== #{node.items.size - 1}"
      else
        condition = "Array.isArray(#{condition_var_name}) && #{condition_var_name}.length === #{node.items.size}"
      end

      variables = [
        "const #{variable} = Array.from(#{start_variable})",
      ] + (
        unless node.spread?
          node.items.map_with_index do |item, index1|
            compile_item! "const #{var_name} = #{variable}[#{index1}]"
          end.flatten
        else
          tmp = [] of Array(String)

          start_vars = node
            .items
            .take_while { |item| !item.is_a?(Ast::Spread) }
            .map_with_index do |item, index1|
              compile_item! "const #{var_name} = #{variable}.shift()"
            end

          end_vars = node
            .items
            .reverse
            .take_while { |item| !item.is_a?(Ast::Spread) }
            .map_with_index do |item, index1|
              compile_item! "const #{var_name} = #{variable}.pop()"
            end

          tmp += start_vars if start_vars
          tmp += end_vars if end_vars

          tmp << ["const #{js.variable_of(node.items.select(Ast::Spread).first.variable)} = #{variable}"]
          tmp.flatten
        end
      )

      {variables, condition}
    end
  end
end
