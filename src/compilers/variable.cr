module Mint
  class Compiler
    def _compile(node : Ast::Variable) : String
      entity, parent = variables[node]

      # Subscriptions for providers are handled here
      if node.value == "subscriptions" && parent.is_a?(Ast::Provider)
        return "this._subscriptions"
      end

      connected = nil

      case parent
      when Ast::Component
        parent.connects.each do |connect|
          store = ast.stores.find(&.name.==(connect.store))

          name =
            case entity
            when Ast::Function then entity.name.value
            when Ast::State    then entity.name.value
            when Ast::Get      then entity.name.value
            when Ast::Constant then entity.name
            end

          if store
            connect.keys.each do |key|
              if (store.functions.includes?(entity) ||
                 store.constants.includes?(entity) ||
                 store.states.includes?(entity) ||
                 store.gets.includes?(entity)) &&
                 key.variable.value == name
                connected = key
              end
            end
          end
        end
      end

      case parent
      when Tuple(String, TypeChecker::Checkable, Ast::Node)
        js.variable_of(parent[2])
      else
        case entity
        when Ast::Component, Ast::HtmlElement
          case parent
          when Ast::Component
            ref =
              parent
                .refs
                .find { |(ref, _)| ref.value == node.value }
                .try { |(ref, _)| js.variable_of(ref) }

            "this.#{ref}"
          else
            raise "SHOULD NOT HAPPEN"
          end
        when Ast::Function
          function =
            if connected
              js.variable_of(connected)
            else
              js.variable_of(entity.as(Ast::Node))
            end

          case parent
          when Ast::Module, Ast::Store
            name =
              js.class_of(parent.as(Ast::Node))

            "#{name}.#{function}"
          else
            "this.#{function}"
          end
        when Ast::Property, Ast::Get, Ast::State, Ast::Constant
          name =
            if connected
              js.variable_of(connected)
            else
              js.variable_of(entity.as(Ast::Node))
            end

          case parent
          when Ast::Suite
            # The variable is a constant in a test suite
            "constants.#{name}()"
          else
            "this.#{name}"
          end
        when Ast::Argument
          compile entity
        when Ast::Statement
          case target = entity.target
          when Ast::Variable
            js.variable_of(target)
          else
            "SHOULD NEVER HAPPEN"
          end
        when Tuple(Ast::Node, Array(Int32) | Int32)
          case item = entity[0]
          when Ast::Statement
            case target = item.target
            when Ast::TupleDestructuring
              case val = entity[1]
              in Int32
                js.variable_of(target.parameters[val])
              in Array(Int32)
                js.variable_of(val.reduce(target) do |curr_type, curr_val|
                  curr_type.as(Ast::TupleDestructuring).parameters[curr_val]
                end)
              end
            else
              js.variable_of(node)
            end
          else
            js.variable_of(node)
          end
        else
          "this.#{node.value}"
        end
      end
    end
  end
end
