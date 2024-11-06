module Mint
  module LS
    class Definitions
      def definition(node : Ast::Variable)
        if lookup = @type_checker.variables[node]?
          entity, parent = lookup

          case {entity, parent}
          when {Ast::TypeDefinition, _}
            location_link node, entity.name, entity
          when {Ast::TypeVariant, _}
            location_link node, entity.value, entity
          when {Ast::Component, _},
               {Ast::Store, _}
            location_link node, entity.name, entity
          when {Ast::Module, _}
            links =
              @type_checker.artifacts.ast.modules
                .select(&.name.value.==(node.value))
                .reject(&.in?(Core.ast.nodes))
                .sort_by!(&.file.path)
                .map do |mod|
                  location_link node, mod.name, mod
                end

            return links.first if links.size == 1
            return links unless links.empty?
          when {Ast::Variable, _}
            variable_lookup_parent(node, entity)
          else
            variable_lookup(node, entity)
          end
        else
          variable_record_key(node) ||
            variable_next_key(node)
        end
      end

      def variable_lookup_parent(node : Ast::Variable, variable : Ast::Variable)
        # For some variables in the .variables` cache, we only have access to the
        # target Ast::Variable and not its containing node, so we must search for it
        return unless parent =
                        @type_checker.artifacts.ast.nodes
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

      def variable_record_key(node : Ast::Variable)
        target =
          @stack[1]?.try do |item|
            case item
            when Ast::Access
              item.field
            when Ast::Field
              item
            end
          end

        if target
          return unless record_name =
                          @type_checker.record_field_lookup[target]?

          return unless record_definition_field =
                          @type_checker.artifacts.ast.type_definitions
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

      def variable_next_key(node : Ast::Variable)
        case next_call = @stack[3]?
        when Ast::NextCall
          return unless parent = next_call.entity

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
