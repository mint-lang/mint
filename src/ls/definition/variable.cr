module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::Variable, workspace : Workspace, stack : Array(Ast::Node))
        lookup = workspace.type_checker.variables[node]?

        if lookup
          variable_lookup_parent(node, lookup[1], workspace) ||
            variable_connect(node, lookup[2]) ||
            variable_lookup(node, lookup[0])
        else
          variable_record_key(node, workspace, stack) ||
            variable_next_key(node, workspace, stack)
        end
      end

      def variable_connect(node : Ast::Variable, parents : Array(TypeChecker::Scope::Node))
        # Check to see if this variable is defined as an Ast::ConnectVariable
        # as the `.variables` cache links directly to the stores state/function etc
        return unless component = parents.select(Ast::Component).first?

        component.connects.each do |connect|
          connect.keys.each do |key|
            variable = key.name || key.variable

            if variable.value == node.value
              return location_link node, variable, connect
            end
          end
        end
      end

      def variable_lookup_parent(node : Ast::Variable, target : TypeChecker::Scope::Node, workspace : Workspace)
        case target
        when Tuple(String, TypeChecker::Checkable, Ast::Node)
          case variable = target[2]
          when Ast::Variable
            # For some variables in the .variables` cache, we only have access to the
            # target Ast::Variable and not its containing node, so we must search for it
            return unless parent = workspace
                            .ast
                            .nodes
                            .select { |other| other.is_a?(Ast::EnumDestructuring) || other.is_a?(Ast::Statement) || other.is_a?(Ast::For) }
                            .select(&.input.file.==(variable.input.file))
                            .find { |other| other.from < variable.from && other.to > variable.to }

            location_link node, variable, parent
          end
        end
      end

      def variable_lookup(node : Ast::Variable, target : Ast::Node | TypeChecker::Checkable)
        case item = target
        when Ast::Node
          name = case item
                 when Ast::Property,
                      Ast::Constant,
                      Ast::Function,
                      Ast::State,
                      Ast::Get,
                      Ast::Argument
                   item.name
                 else
                   item
                 end

          location_link node, name, item
        end
      end

      def variable_record_key(node : Ast::Variable, workspace : Workspace, stack : Array(Ast::Node))
        case field = stack[1]?
        when Ast::RecordField
          return unless record_name = workspace.type_checker.record_field_lookup[field]?

          return unless record_definition_field = workspace
                          .ast
                          .records
                          .find(&.name.value.==(record_name))
                          .try(&.fields.find(&.key.value.==(node.value)))

          location_link node, record_definition_field.key, record_definition_field
        end
      end

      def variable_next_key(node : Ast::Variable, workspace : Workspace, stack : Array(Ast::Node))
        case next_call = stack[3]?
        when Ast::NextCall
          return unless parent = workspace.type_checker.lookups[next_call]

          return unless state = case parent
                                when Ast::Provider, Ast::Component, Ast::Store
                                  parent.states.find(&.name.value.==(node.value))
                                end

          location_link node, state.name, state
        end
      end
    end
  end
end
