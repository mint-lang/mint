module Mint
  class Compiler
    def _compile(node : Ast::ArrayDestructuring, start_variable, index : Int32? = nil, prev_cond_var_name : String? = nil) : {Array(String), String}
      variable = "__"

      condition_var_name = prev_cond_var_name || start_variable
      condition_var_name += "[#{index}]" if index
      if node.spread?
        condition = "Array.isArray(#{condition_var_name}) && #{condition_var_name}.length >== #{node.items.size - 1}"
      else
        condition = "Array.isArray(#{condition_var_name}) && #{condition_var_name}.length === #{node.items.size}"
      end

      _compile_destruction_item = ->(item : Ast::Node, var_name : String, index : Int32, vars : Array(String)) {
        if item.is_a? Ast::DestructuringType
          res = case item
                when Ast::ArrayDestructuring
                  _compile item, var_name, index, condition_var_name
                when Ast::TupleDestructuring
                  _compile item, var_name, index
                when Ast::EnumDestructuring
                  _compile item, var_name, index
                else
                  # ignore
                end.not_nil!
          condition += " && " + res[1]
          vars.concat(res[0])
        end
      }

      variables = [
        "const #{variable} = Array.from(#{start_variable})",
      ] + (
        unless node.spread?
          node.items.map_with_index do |item, index1|
            var_name = js.variable_of(item)
            vars = [
              "const #{var_name} = #{variable}[#{index1}]",
            ]

            _compile_destruction_item.call item, var_name, index1, vars

            vars
          end.flatten
        else
          tmp = [] of Array(String)

          node
            .items
            .take_while { |item| !item.is_a?(Ast::Spread) }
            .each_with_index do |item, index1|
              var_name = js.variable_of(item)
              vars = [
                "const #{var_name} = #{variable}.shift()",
              ]

              _compile_destruction_item.call item, var_name, index1, vars

              vars
            end.try { |vars| tmp.concat(vars) }

          node
            .items
            .reverse
            .take_while { |item| !item.is_a?(Ast::Spread) }
            .each_with_index do |item, index1|
              var_name = js.variable_of(item)
              vars = [
                "const #{var_name} = #{variable}.pop()",
              ]

              _compile_destruction_item.call item, var_name, index1, vars

              vars
            end.try { |vars| tmp.concat(vars) }
          tmp << ["const #{js.variable_of(node.items.select(Ast::Spread).first.variable)} = #{variable}"]
          tmp.flatten
        end
      )

      {variables, condition}
    end
  end
end
