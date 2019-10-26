module Mint
  class Compiler
    def compile(node : Ast::CaseBranch,
                index : Int32,
                variable : String,
                block : Proc(String, String) | Nil = nil) : String
      if checked.includes?(node)
        _compile node, index, variable, block
      else
        ""
      end
    end

    def _compile(node : Ast::CaseBranch,
                 index : Int32,
                 variable : String,
                 block : Proc(String, String) | Nil = nil) : String
      expression =
        case item = node.expression
        when Array(Ast::CssDefinition)
          compiled =
            if block
              _compile item, block
            else
              "{}"
            end
        when Ast::Node
          js.return(compile(item))
        else
          ""
        end

      if match = node.match
        case match
        when Ast::EnumDestructuring
          variables =
            match.parameters.map_with_index do |param, index1|
              "const #{js.variable_of(param)} = #{variable}._#{index1}"
            end

          name =
            js.class_of(lookups[match])

          js.if("#{variable} instanceof #{name}") do
            js.statements(variables + [expression])
          end
        else
          compiled =
            compile match

          if index == 0
            js.if("_compare(#{variable}, #{compiled})") do
              expression
            end
          else
            js.elseif("_compare(#{variable}, #{compiled})") do
              expression
            end
          end
        end
      else
        js.else do
          expression
        end
      end
    end
  end
end
