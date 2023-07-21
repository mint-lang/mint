module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::EnumId, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        name = node.name

        # When `.name` is nil the node is used as a CONSTANT
        if name.nil?
          stack.each do |parent|
            case parent
            when Ast::Component,
                 Ast::Store,
                 Ast::Suite,
                 Ast::Module,
                 Ast::Provider
              parent.constants.each do |constant|
                if node.option.value == constant.name.value
                  return location_link server, node.option, constant.name, constant
                end
              end
            end
          end
        else
          return unless enum_node =
                          workspace.ast.enums.find(&.name.value.==(name.value))

          return if Core.ast.enums.includes?(enum_node)

          case
          when cursor_intersects?(name)
            location_link server, name, enum_node.name, enum_node
          when cursor_intersects?(node.option)
            return unless option =
                            enum_node.try &.options.find(&.value.value.==(node.option.value))

            location_link server, node.option, option.value, option
          end
        end
      end
    end
  end
end
