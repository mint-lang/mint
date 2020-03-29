module Mint
  class TypeChecker
    type_error VariableReserved
    type_error VariableMissing

    RESERVED =
      %w(break case catch class const continue debugger default delete do else
        export extends finally for function if import in instanceof new return
        super switch this throw try typeof var void while with yield state
        sequence parallel)

    def check(node : Ast::Variable) : Checkable
      raise VariableReserved, {
        "name" => node.value,
        "node" => node,
      } if RESERVED.includes?(node.value)

      item = lookup_with_level(node)

      raise VariableMissing, {
        "name" => node.value,
        "node" => node,
      } unless item

      variables[node] = item

      if item[0].is_a?(Ast::HtmlElement) && item[1].is_a?(Ast::Component)
        Type.new("Maybe", [Type.new("Dom.Element")] of Checkable)
      elsif item[0].is_a?(Ast::Component) && item[1].is_a?(Ast::Component)
        Type.new("Maybe", [component_records[item[0]]] of Checkable)
      else
        case value = item[0]
        when Ast::Statement
          type = resolve value

          if value.parent == Ast::Statement::Parent::Try
            if type.name == "Result" && type.parameters.size == 2
              type.parameters[1]
            else
              type
            end
          else
            if type.name.in?("Result", "Promise") && type.parameters.size == 2
              type.parameters[1]
            else
              type
            end
          end
        when Tuple(Ast::Node, Int32)
          item = value[0]

          type =
            resolve item

          case item
          when Ast::Statement, Ast::WhereStatement
            case item.target
            when Ast::TupleDestructuring
              type.parameters[value[1]]
            else
              type
            end
          else
            type
          end
        when Ast::Node
          resolve value
        when Checkable
          value
        else
          NEVER
        end
      end
    end
  end
end
