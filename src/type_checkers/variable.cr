module Mint
  class TypeChecker
    type_error VariableReserved
    type_error VariableMissing

    RESERVED =
      %w(break case class const continue debugger default delete do else
        export extends for if import in instanceof new return super
        switch this throw typeof var void while yield state)

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

      case
      when item[0].is_a?(Ast::HtmlElement) && item[1].is_a?(Ast::Component)
        Type.new("Maybe", [Type.new("Dom.Element")] of Checkable)
      when item[0].is_a?(Ast::Component) && item[1].is_a?(Ast::Component)
        Type.new("Maybe", [component_records[item[0]]] of Checkable)
      else
        case value = item[0]
        when Ast::Statement
          resolve value
        when Tuple(Ast::Node, Int32 | Array(Int32))
          item = value[0]

          type =
            resolve item

          case item
          when Ast::Statement
            case item.target
            when Ast::TupleDestructuring
              case val = value[1]
              in Int32
                type.parameters[val]
              in Array(Int32)
                val.reduce(type) { |curr_type, curr_val| curr_type.parameters[curr_val] }
              end
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
          VOID
        end
      end
    end
  end
end
