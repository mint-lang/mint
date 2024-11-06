module Mint
  module LS
    class Definitions
      def definition(node : Ast::Id)
        case next_node = @stack[1]?
        when Ast::TypeDestructuring
          if (type_definition =
               @type_checker.artifacts.ast.type_definitions
                 .find(&.name.value.==(node.value))) &&
             !Core.ast.nodes.includes?(type_definition)
            location_link node, type_definition.name, type_definition
          else
            definition(next_node)
          end
        else
          found =
            @type_checker.artifacts.ast.type_definitions.find(&.name.value.==(node.value)) ||
              @type_checker.artifacts.ast.stores.find(&.name.value.==(node.value)) ||
              find_component(node.value)

          if found.nil? && next_node
            return definition(next_node)
          end

          return if Core.ast.nodes.includes?(found)

          case found
          when Ast::Store, Ast::Component, Ast::TypeDefinition
            location_link node, found.name, found
          end
        end
      end
    end
  end
end
