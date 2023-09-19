module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::Variable, workspace : Workspace, stack : Array(Ast::Node))
        lookup = workspace.type_checker.variables[node]?

        if lookup
          entity, parent = lookup

          case {entity, parent}
          when {Ast::Component, _},
               {Ast::Store, _}
            location_link node, entity.name, entity
          when {Ast::Module, _}
            links = workspace.ast.modules
              .select(&.name.value.==(node.value))
              .reject(&.in?(Core.ast.nodes))
              .sort_by!(&.file.path)
              .map do |mod|
                location_link node, mod.name, mod
              end

            return links.first if links.size == 1
            return links unless links.empty?
          when {Ast::Variable, _}
            variable_lookup_parent(node, entity, workspace)
          when {Ast::ConnectVariable, Ast::Node}
            connect =
              workspace.ast.nodes
                .select(Ast::Connect)
                .find!(&.keys.find(&.==(entity)))

            key =
              lookup[0].as(Ast::ConnectVariable)

            location_link node, key.target || key.name, connect
          else
            variable_lookup(node, entity)
          end
        else
          variable_record_key(node, workspace, stack) ||
            variable_next_key(node, workspace, stack)
        end
      end

      def variable_lookup_parent(node : Ast::Variable, variable : Ast::Variable, workspace : Workspace)
        # For some variables in the .variables` cache, we only have access to the
        # target Ast::Variable and not its containing node, so we must search for it
        return unless parent = workspace
                        .ast
                        .nodes
                        .select { |other| other.is_a?(Ast::TypeDestructuring) || other.is_a?(Ast::Statement) || other.is_a?(Ast::For) }
                        .select(&.file.path.==(variable.file.path))
                        .find { |other| other.from < variable.from && other.to > variable.to }

        location_link node, variable, parent
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
        when Ast::Field
          return unless record_name = workspace.type_checker.record_field_lookup[field]?

          return unless record_definition_field = workspace
                          .ast
                          .type_definitions
                          .find(&.name.value.==(record_name))
                          .try do |item|
                            case fields = item.fields
                            when Array(Ast::TypeDefinitionField)
                              fields.find(&.key.value.==(node.value))
                            end
                          end

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
