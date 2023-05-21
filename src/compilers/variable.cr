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
          store = ast.stores.find(&.name.value.==(connect.store.value))

          name =
            case entity
            when Ast::Function, Ast::State, Ast::Get, Ast::Constant
              entity.name.value
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
          js.variable_of(entity)
        else
          "this.#{node.value}"
        end
      end
    end
  end
end
